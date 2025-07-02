# 🌿 PlantCare

PlantCare je aplikacija koja pomaže korisnicima u brizi o biljkama kroz kataloge, blog postove i korisne komentare. Sastoji se od dvije aplikacije:

- 🖥️ **Desktop aplikacija (Admin panel)** — upravljanje korisnicima, postovima, kategorijama, obavijestima, katalozima, izvještajima i više.  
- 📱 **Mobilna aplikacija (Korisnici)** — pregled postova, komentari, omiljeni postovi, premium sadržaj, katalogi, korisnički profil i još mnogo toga.

---

## 🔐 Prijava

### 🖥️ Desktop aplikacija (Admin)
- **Korisničko ime:** `ana_admin`  
- **Lozinka:** `test`

### 📱 Mobilna aplikacija

**Regularni korisnik:**
- **Korisničko ime:** `saras`  
- **Lozinka:** `test`

**Premium korisnik:**
- **Korisničko ime:** `marko_mod`  
- **Lozinka:** `test`

---

## 💳 Testni podaci za plaćanje (Stripe)

PlantCare koristi Stripe za testne transakcije:

- **Broj kartice:** `4242 4242 4242 4242`  
- **CVC:** `222`  
- **Datum isteka:** Bilo koji budući datum  

🔗 Više testnih kartica: [Stripe Test Kreditne Kartice](https://stripe.com/docs/testing#international-cards)

---

## 📩 Napomena

Za testiranje registracije korisnika potreban je validan email kako bi korisnik primio poruku dobrodošlice putem emaila.

---

## 🚀 Pokretanje aplikacije

```bash
# 1️⃣ Kloniranje repozitorija
git clone https://github.com/mustafaisic000/PlantCare.git

# 2️⃣ Pokretanje API-ja i baze podataka (Docker)
cd PlantCare
docker-compose up --build

# Ovo će pokrenuti:
# - ASP.NET Core backend (backend/)
# - PostgreSQL bazu
# - pgAdmin za vizuelni prikaz baze
# 📌 Provjeri da li su portovi u .env datoteci pravilno podešeni

# 3️⃣ Pokretanje desktop aplikacije (Admin)
cd ui/plantcare_desktop
flutter pub get
flutter run -d windows
# 📌 Ako koristiš macOS ili Linux, koristi -d macos ili -d linux

# 4️⃣ Pokretanje mobilne aplikacije (Korisnici)
cd ../plantcare_mobile
flutter pub get
# Pokreni Android/iOS emulator
flutter run
# Ili bez debuggiranja:
# CTRL + F5
