# Product Project — Flutter + Firebase

Flutter CRUD app for admin product management on web and Android.

## Firebase setup

- Firebase project: `thigiuaki-d30be`
- Authentication: Email/Password for admin login
- Firestore collection: `products`
- Document fields: `name` (String), `price` (Number), `soluong` (Integer), `image` (Base64 JPEG String)
- Images are compressed and stored in Firestore; Firebase Storage is not required.

## Run the web app

```powershell
flutter pub get
flutter run -d chrome
```

Deploy Firestore rules from this project folder:

```powershell
firebase.cmd use thigiuaki-d30be
firebase.cmd deploy --only firestore:rules
```

## Source layout

- `lib/data/`: product model, Firestore repository, and admin authentication repository.
- `lib/screens/`: login and responsive product administration screens.
- `lib/widgets/`: reusable admin UI components and product form/image picker.
- `firestore.rules`: admin-only rules enforcing the exact four-field product schema.
- `products_sample.json`: sample Firestore document with only the required fields.
- `BAO_CAO.md` and `BAO_CAO.docx`: project report; add real screenshots and submission links before handing in.
