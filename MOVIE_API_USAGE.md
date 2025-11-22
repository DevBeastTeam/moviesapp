# Movie API Usage Guide

All movie API endpoints are now implemented in `MoviesController`. Here's how to use them:

## Available Methods

### 1. Get Movie List
```dart
final controller = Get.find<MoviesController>();
await controller.fetchMovies();
// Access data:
// - controller.subjects (List<MovieSubject>)
// - controller.tags (List<MovieTag>)
// - controller.groupMovies (Map<String, List<Movie>>)
// - controller.moviesByTag (List<Map<String, dynamic>>)
```

### 2. Get Movie Details
```dart
final controller = Get.find<MoviesController>();
final movieData = await controller.fetchMovieDetails('movieId');
// Returns: Map<String, dynamic> with movie details
```

### 3. Get Movie Questions ✅ NEW
```dart
final controller = Get.find<MoviesController>();
final questions = await controller.getMovieQuestions('movieId');
// Returns: List<dynamic> of questions
// Example:
// [
//   {
//     "_id": "123",
//     "label": "Question text?",
//     "start": 10,
//     "end": 20,
//     "answers": [...]
//   }
// ]
```

### 4. Update Movie History ✅ NEW
```dart
final controller = Get.find<MoviesController>();
final success = await controller.updateMovieHistory(
  'movieId',
  status: 'paused', // or 'ended', 'playing'
  time: 120, // Time in seconds
);
// Returns: bool (true if successful)
```

### 5. Get Movie Subjects ✅ NEW
```dart
final controller = Get.find<MoviesController>();
final subjects = await controller.getMovieSubjects('movieId');
// Returns: dynamic (Map with subjects data)
```

## Example: Complete Movie Player Flow

```dart
class MoviePlayerExample extends StatefulWidget {
  final String movieId;
  
  @override
  _MoviePlayerExampleState createState() => _MoviePlayerExampleState();
}

class _MoviePlayerExampleState extends State<MoviePlayerExample> {
  final controller = Get.find<MoviesController>();
  List<dynamic> questions = [];
  int currentTime = 0;
  
  @override
  void initState() {
    super.initState();
    loadMovieData();
  }
  
  Future<void> loadMovieData() async {
    // 1. Get movie details
    final movieData = await controller.fetchMovieDetails(widget.movieId);
    
    // 2. Get questions for this movie
    questions = await controller.getMovieQuestions(widget.movieId);
    
    // 3. Get subjects (if needed)
    final subjects = await controller.getMovieSubjects(widget.movieId);
    
    setState(() {});
  }
  
  Future<void> onPause(int timeInSeconds) async {
    // Save progress when user pauses
    await controller.updateMovieHistory(
      widget.movieId,
      status: 'paused',
      time: timeInSeconds,
    );
  }
  
  Future<void> onComplete(int timeInSeconds) async {
    // Mark as ended when movie finishes
    await controller.updateMovieHistory(
      widget.movieId,
      status: 'ended',
      time: timeInSeconds,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Video player here
          Text('Questions: ${questions.length}'),
          // Show questions at appropriate times
        ],
      ),
    );
  }
}
```

## API Endpoints Status

✅ `GET /movies/list` - List movies  
✅ `GET /movies/{id}` - Get movie details  
✅ `GET /movies/{id}/questions` - Get movie questions  
✅ `POST /movies/{id}/history` - Update movie watch history  
✅ `GET /movies/{movieId}/subjects` - Get movie subjects  

All movie API endpoints are now fully implemented with:
- ✅ Proper error handling
- ✅ Debug logging
- ✅ Type safety
- ✅ Null safety
- ✅ Easy-to-use interface
