using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using PlantCare.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;

public class PostRecommender
{
    private static readonly MLContext mlContext = new MLContext();
    private static readonly object _lock = new object();
    private static ITransformer model;
    private readonly PlantCareContext _context;

    public PostRecommender(PlantCareContext context)
    {
        _context = context;
    }

    public List<Post> Recommend(int korisnikId)
    {
        lock (_lock)
        {
            var interactions = _context.Lajkovi
                .Select(x => new UserItemEntry
                {
                    UserId = (uint)x.KorisnikId,
                    ItemId = (uint)x.PostId,
                    Rating = 1
                })
                .Union(_context.OmiljeniPostovi
                    .Select(x => new UserItemEntry
                    {
                        UserId = (uint)x.KorisnikId,
                        ItemId = (uint)x.PostId,
                        Rating = 3
                    }))
                .ToList();

            if (interactions.Count == 0)
                return new List<Post>();

            var dataView = mlContext.Data.LoadFromEnumerable(interactions);

            var options = new MatrixFactorizationTrainer.Options
            {
                MatrixColumnIndexColumnName = nameof(UserItemEntry.UserId),
                MatrixRowIndexColumnName = nameof(UserItemEntry.ItemId),
                LabelColumnName = nameof(UserItemEntry.Rating),
                LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass,
                Alpha = 0.01,
                Lambda = 0.025,
                NumberOfIterations = 100,
                C = 0.00001
            };

            var trainer = mlContext.Recommendation().Trainers.MatrixFactorization(options);
            model = trainer.Fit(dataView);
        }

        var unseenPosts = _context.Postovi
            .Where(p => !_context.Lajkovi.Any(l => l.KorisnikId == korisnikId && l.PostId == p.PostId)
                     && !_context.OmiljeniPostovi.Any(o => o.KorisnikId == korisnikId && o.PostId == p.PostId)
                     && p.Status == true)
            .ToList();

        var results = new List<Tuple<Post, float>>();

        foreach (var post in unseenPosts)
        {
            var predictionEngine = mlContext.Model.CreatePredictionEngine<UserItemEntry, PostPrediction>(model);
            var prediction = predictionEngine.Predict(new UserItemEntry
            {
                UserId = (uint)korisnikId,
                ItemId = (uint)post.PostId
            });

            results.Add(new Tuple<Post, float>(post, prediction.Score));
        }

        return results.OrderByDescending(x => x.Item2).Select(x => x.Item1).Take(4).ToList();
    }

    public class UserItemEntry
    {
        [KeyType(count: 1000)]
        public uint UserId { get; set; }

        [KeyType(count: 1000)]
        public uint ItemId { get; set; }

        public float Rating { get; set; }
    }

    public class PostPrediction
    {
        public float Score { get; set; }
    }
}
