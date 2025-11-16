class Lesson {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final LessonType type;
  final String content;
  final int difficulty; // 1-5
  final List<String> tags;
  final bool isCompleted;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.type,
    required this.content,
    required this.difficulty,
    required this.tags,
    this.isCompleted = false,
  });
}

enum LessonType {
  reading,
  speaking,
  vocabulary,
  grammar,
}

// Sample data
List<Lesson> sampleLessons = [
  Lesson(
    id: '1',
    title: 'Basic Greetings',
    description: 'Learn common Somali greetings and introductions',
    imageUrl: 'assets/images/greetings.jpg',
    type: LessonType.reading,
    content: 'Iska waran? (How are you?)\nWaan fiicanahay, mahadsanid. (I am fine, thank you.)\nMagacaygu waa... (My name is...)',
    difficulty: 1,
    tags: ['beginner', 'greetings'],
  ),
  Lesson(
    id: '2',
    title: 'Family Members',
    description: 'Learn vocabulary for family relationships',
    imageUrl: 'assets/images/family.jpg',
    type: LessonType.vocabulary,
    content: 'Aabo (Father)\nHooyo (Mother)\nWalaal (Sibling)\nAdeer (Uncle)\nEeddo (Aunt)',
    difficulty: 2,
    tags: ['beginner', 'vocabulary'],
  ),
  Lesson(
    id: '3',
    title: 'Daily Conversations',
    description: 'Practice everyday conversations in Somali',
    imageUrl: 'assets/images/conversation.jpg',
    type: LessonType.speaking,
    content: 'Xaggee baad ku nooshahay? (Where do you live?)\nWaxaan ku noolahay... (I live in...)',
    difficulty: 3,
    tags: ['intermediate', 'conversation'],
  ),
  Lesson(
    id: '4',
    title: 'Somali Proverbs',
    description: 'Learn traditional Somali proverbs and their meanings',
    imageUrl: 'assets/images/proverbs.jpg',
    type: LessonType.reading,
    content: 'Aqoon la\'aan waa iftiin la\'aan. (Not having knowledge is not having light.)',
    difficulty: 4,
    tags: ['advanced', 'culture'],
  ),
];
