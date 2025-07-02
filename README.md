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

### 1️⃣ Kloniranje repozitorija

```bash
git clone https://github.com/mustafaisic000/PlantCare.git

### 2️⃣ Pokretanje API-ja i baze podataka (Docker)
U glavnom PlantCare direktoriju pokreni:
```bash
docker-compose up --build

### 3️⃣ Pokretanje desktop aplikacije (Admin)
Otvori folder PlantCare/ui/plantcare_desktop u Visual Studio Code
Instaliraj sve zavisnosti:
```bash
flutter pub get
Pokreni aplikaciju:
```bash
flutter run -d windows
📌 Ako koristiš macOS ili Linux, koristi odgovarajući -d parametar (macos, linux).

### 4️⃣ Pokretanje mobilne aplikacije (Korisnici)
Otvori folder PlantCare/ui/plantcare_mobile u Visual Studio Code

Instaliraj zavisnosti:
```bash
flutter pub get

Pokreni Android/iOS emulator
Pokreni aplikaciju:
```bash
flutter run
Ili bez debuggiranja:
```bash
CTRL + F5
