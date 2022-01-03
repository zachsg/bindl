# bodai
Bodai mobile meal-planning app.

## Dev

### Editing / changing models

When any model objects (that are saved to the DB) are changed, run the following command:

`flutter packages pub run build_runner build`

This will rebuild the JSON serialization helper models automatically (generates `filename.g.dart` files).
