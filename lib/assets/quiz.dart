import 'package:study_app/models/models.dart';

final List<Map<String, dynamic>> _courses = [
  {
    'image':
        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
    'title': 'Introduction to Computer Science',
    'faculty': 'Faculty of Computer Science',
    'flash_cards': [
      {
        'question': 'What is a computer?',
        'answer': 'A machine',
      },
      {
        'question': 'Who is the father of computer science?',
        'answer': 'Alan Turing',
      },
      {
        'question': 'What does CPU stand for?',
        'answer': 'Central Processing Unit',
      },
      {
        'question': 'What is the binary system?',
        'answer': 'A number system with 0 and 1',
      },
      {
        'question': 'What is an algorithm?',
        'answer': 'A set of instructions',
      },
    ],
    'quizzes': [
      {
        'title': 'Quiz 1: Basics of Computer Science',
        'questions': [
          {
            'question': 'What is a computer?',
            'options': ['A machine', 'An animal', 'A vehicle', 'A building'],
            'answer': 'A machine'
          },
          {
            'question': 'Who is the father of computer science?',
            'options': [
              'Alan Turing',
              'Albert Einstein',
              'Isaac Newton',
              'Galileo Galilei'
            ],
            'answer': 'Alan Turing'
          },
          {
            'question': 'What does CPU stand for?',
            'options': [
              'Central Processing Unit',
              'Computer Personal Unit',
              'Central Personal Unit',
              'Central Program Unit'
            ],
            'answer': 'Central Processing Unit'
          },
          {
            'question': 'What is the binary system?',
            'options': [
              'A number system with 0 and 1',
              'A type of computer',
              'A software language',
              'A hardware component'
            ],
            'answer': 'A number system with 0 and 1'
          },
          {
            'question': 'What is an algorithm?',
            'options': [
              'A set of instructions',
              'A software',
              'A hardware',
              'A type of network'
            ],
            'answer': 'A set of instructions'
          }
        ]
      },
      {
        'title': 'Quiz 2: History of Computers',
        'questions': [
          {
            'question': 'Who developed the first mechanical computer?',
            'options': [
              'Charles Babbage',
              'Alan Turing',
              'Steve Jobs',
              'Bill Gates'
            ],
            'answer': 'Charles Babbage'
          },
          {
            'question': 'What was the name of the first electronic computer?',
            'options': ['ENIAC', 'UNIVAC', 'IBM', 'MAC'],
            'answer': 'ENIAC'
          },
          {
            'question': 'What is the language of computers?',
            'options': ['Binary', 'English', 'Hexadecimal', 'Decimal'],
            'answer': 'Binary'
          },
          {
            'question': 'Which generation used vacuum tubes?',
            'options': ['First', 'Second', 'Third', 'Fourth'],
            'answer': 'First'
          },
          {
            'question': 'Which company created the first personal computer?',
            'options': ['IBM', 'Microsoft', 'Apple', 'Intel'],
            'answer': 'IBM'
          }
        ]
      },
      {
        'title': 'Quiz 3: Software Basics',
        'questions': [
          {
            'question': 'What is software?',
            'options': [
              'Programs and applications',
              'Physical parts of computer',
              'Users',
              'Networks'
            ],
            'answer': 'Programs and applications'
          },
          {
            'question': 'Which of these is an operating system?',
            'options': ['Windows', 'Intel', 'HTML', 'CPU'],
            'answer': 'Windows'
          },
          {
            'question': 'What does RAM stand for?',
            'options': [
              'Random Access Memory',
              'Read Access Memory',
              'Run Access Memory',
              'Read Action Memory'
            ],
            'answer': 'Random Access Memory'
          },
          {
            'question': 'Which of these is a programming language?',
            'options': ['Python', 'Microsoft', 'Intel', 'NVIDIA'],
            'answer': 'Python'
          },
          {
            'question': 'What does GUI stand for?',
            'options': [
              'Graphical User Interface',
              'General User Information',
              'Guide Using Instructions',
              'Graph Under Interface'
            ],
            'answer': 'Graphical User Interface'
          }
        ]
      },
    ]
  },
  {
    'image':
        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
    'title': 'Data Structures & Algorithms',
    'faculty': 'Faculty of Computer Science',
    'flash_cards': [
      {
        'question': 'What is an array?',
        'answer': 'Collection of elements',
      },
      {
        'question': 'What is the time complexity of binary search?',
        'answer': 'O(log n)',
      },
      {
        'question': 'Which data structure uses LIFO?',
        'answer': 'Stack',
      },
      {
        'question': 'What is a linked list?',
        'answer': 'A sequence of nodes',
      },
      {
        'question': 'What does FIFO stand for?',
        'answer': 'First In, First Out',
      },
    ],
    'quizzes': [
      {
        'title': 'Quiz 1: Data Structures',
        'questions': [
          {
            'question': 'What is an array?',
            'options': [
              'Collection of elements',
              'Single data',
              'A function',
              'A loop'
            ],
            'answer': 'Collection of elements'
          },
          {
            'question': 'What is the time complexity of binary search?',
            'options': ['O(log n)', 'O(n)', 'O(n^2)', 'O(n log n)'],
            'answer': 'O(log n)'
          },
          {
            'question': 'Which data structure uses LIFO?',
            'options': ['Stack', 'Queue', 'Array', 'Graph'],
            'answer': 'Stack'
          },
          {
            'question': 'What is a linked list?',
            'options': [
              'A sequence of nodes',
              'A type of array',
              'A loop structure',
              'A class in programming'
            ],
            'answer': 'A sequence of nodes'
          },
          {
            'question': 'What does FIFO stand for?',
            'options': [
              'First In, First Out',
              'First In, Last Out',
              'Fast In, Fast Out',
              'Few In, Few Out'
            ],
            'answer': 'First In, First Out'
          }
        ]
      },
      {
        'title': 'Quiz 2: Sorting Algorithms',
        'questions': [
          {
            'question': 'What is the time complexity of bubble sort?',
            'options': ['O(n^2)', 'O(log n)', 'O(n)', 'O(n log n)'],
            'answer': 'O(n^2)'
          },
          {
            'question': 'Which sorting algorithm is the fastest in most cases?',
            'options': [
              'Quick Sort',
              'Bubble Sort',
              'Insertion Sort',
              'Selection Sort'
            ],
            'answer': 'Quick Sort'
          },
          {
            'question': 'Which algorithm is not a comparison-based sort?',
            'options': [
              'Radix Sort',
              'Merge Sort',
              'Quick Sort',
              'Bubble Sort'
            ],
            'answer': 'Radix Sort'
          },
          {
            'question': 'What does merge sort use to divide data?',
            'options': [
              'Divide and conquer',
              'Selection',
              'Swapping',
              'Copying'
            ],
            'answer': 'Divide and conquer'
          },
          {
            'question': 'Which algorithm is best for nearly sorted data?',
            'options': [
              'Insertion Sort',
              'Selection Sort',
              'Heap Sort',
              'Bubble Sort'
            ],
            'answer': 'Insertion Sort'
          }
        ]
      },
      {
        'title': 'Quiz 3: Graph Theory',
        'questions': [
          {
            'question': 'What is a graph?',
            'options': [
              'Set of vertices and edges',
              'Array of numbers',
              'Only vertices',
              'Set of sorted data'
            ],
            'answer': 'Set of vertices and edges'
          },
          {
            'question': 'Which algorithm is used to find shortest path?',
            'options': [
              'Dijkstra\'s Algorithm',
              'Bubble Sort',
              'Insertion Sort',
              'Quick Sort'
            ],
            'answer': 'Dijkstra\'s Algorithm'
          },
          {
            'question': 'What is a tree?',
            'options': [
              'A connected acyclic graph',
              'A type of stack',
              'A sorting algorithm',
              'A collection of arrays'
            ],
            'answer': 'A connected acyclic graph'
          },
          {
            'question': 'What does BFS stand for?',
            'options': [
              'Breadth-First Search',
              'Binary First Sort',
              'Binary Fast Search',
              'Base File System'
            ],
            'answer': 'Breadth-First Search'
          },
          {
            'question':
                'In a binary tree, how many children does each node have?',
            'options': ['At most two', 'At most one', 'Three', 'Four'],
            'answer': 'At most two'
          }
        ]
      },
    ]
  },
  {
    'image':
        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
    'title': 'Linear Algebra',
    'faculty': 'Faculty of Mathematics',
    'flash_cards': [
      {
        'question': 'What is a matrix?',
        'answer': 'A rectangular array of numbers',
      },
      {
        'question': 'What does a 2x3 matrix mean?',
        'answer': '2 rows, 3 columns',
      },
      {
        'question': 'What is the transpose of a matrix?',
        'answer': 'Flipping rows and columns',
      },
      {
        'question': 'What is a scalar?',
        'answer': 'A single number',
      },
      {
        'question': 'What is the identity matrix?',
        'answer': 'A matrix with ones on the diagonal',
      },
    ],
    'quizzes': [
      {
        'title': 'Quiz 1: Matrix Basics',
        'questions': [
          {
            'question': 'What is a matrix?',
            'options': [
              'A rectangular array of numbers',
              'A single number',
              'A complex number',
              'A geometric shape'
            ],
            'answer': 'A rectangular array of numbers'
          },
          {
            'question': 'What does a 2x3 matrix mean?',
            'options': [
              '2 rows, 3 columns',
              '3 rows, 2 columns',
              '2 columns, 3 rows',
              '3 columns, 3 rows'
            ],
            'answer': '2 rows, 3 columns'
          },
          {
            'question': 'What is the transpose of a matrix?',
            'options': [
              'Flipping rows and columns',
              'Adding to each element',
              'Squaring each element',
              'Finding inverse of the matrix'
            ],
            'answer': 'Flipping rows and columns'
          },
          {
            'question': 'What is a scalar?',
            'options': [
              'A single number',
              'A matrix',
              'A vector',
              'A variable'
            ],
            'answer': 'A single number'
          },
          {
            'question': 'What is the identity matrix?',
            'options': [
              'A matrix with ones on the diagonal',
              'A matrix with all zeroes',
              'A square matrix',
              'A symmetric matrix'
            ],
            'answer': 'A matrix with ones on the diagonal'
          }
        ]
      },
      {
        'title': 'Quiz 2: Vector Spaces',
        'questions': [
          {
            'question': 'What is a vector?',
            'options': [
              'A quantity with magnitude and direction',
              'Only magnitude',
              'Only direction',
              'A function'
            ],
            'answer': 'A quantity with magnitude and direction'
          },
          {
            'question': 'What is a basis in a vector space?',
            'options': [
              'Set of linearly independent vectors',
              'Any collection of vectors',
              'The zero vector',
              'A single vector'
            ],
            'answer': 'Set of linearly independent vectors'
          },
          {
            'question': 'What is a subspace?',
            'options': [
              'Subset of a vector space',
              'Matrix of rows and columns',
              'A vector in space',
              'A single number'
            ],
            'answer': 'Subset of a vector space'
          },
          {
            'question': 'What is the zero vector?',
            'options': [
              'A vector with all components zero',
              'A vector with one component',
              'A vector in the opposite direction',
              'A vector in any direction'
            ],
            'answer': 'A vector with all components zero'
          },
          {
            'question': 'What does it mean for vectors to be orthogonal?',
            'options': [
              'They are at right angles',
              'They are parallel',
              'They are the same length',
              'They are perpendicular to a plane'
            ],
            'answer': 'They are at right angles'
          }
        ]
      },
      {
        'title': 'Quiz 3: Linear Transformations',
        'questions': [
          {
            'question': 'What is a linear transformation?',
            'options': [
              'A function that preserves vector addition and scalar multiplication',
              'A type of matrix',
              'A form of addition',
              'A zero function'
            ],
            'answer':
                'A function that preserves vector addition and scalar multiplication'
          },
          {
            'question': 'What is the image of a transformation?',
            'options': [
              'The set of all outputs',
              'The inputs of the function',
              'The zero vector',
              'The origin'
            ],
            'answer': 'The set of all outputs'
          },
          {
            'question': 'What is the kernel of a transformation?',
            'options': [
              'The set of all vectors mapped to zero',
              'The set of all outputs',
              'The basis of a vector space',
              'The range of a function'
            ],
            'answer': 'The set of all vectors mapped to zero'
          },
          {
            'question': 'What is an eigenvector?',
            'options': [
              'A vector that does not change direction under transformation',
              'A vector mapped to zero',
              'The shortest vector in a space',
              'A vector with no length'
            ],
            'answer':
                'A vector that does not change direction under transformation'
          },
          {
            'question': 'What is an eigenvalue?',
            'options': [
              'The scalar associated with an eigenvector',
              'The smallest element in a matrix',
              'The largest value in a vector',
              'The sum of all elements'
            ],
            'answer': 'The scalar associated with an eigenvector'
          }
        ]
      },
    ]
  },
  {
    'image':
        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
    'title': 'Marketing 101',
    'faculty': 'Faculty of Business',
    'flash_cards': [
      {
        'question': 'What is marketing?',
        'answer': 'Process of promoting products',
      },
      {
        'question': 'Which of these is part of the 4Ps of marketing?',
        'answer': 'Product',
      },
      {
        'question': 'What is a target market?',
        'answer': 'A specific group of customers',
      },
      {
        'question': 'What does branding mean?',
        'answer': 'Creating a unique identity',
      },
      {
        'question': 'What is a market segment?',
        'answer': 'A group with similar needs',
      },
    ],
    'quizzes': [
      {
        'title': 'Quiz 1: Marketing Basics',
        'questions': [
          {
            'question': 'What is marketing?',
            'options': [
              'Process of promoting products',
              'Process of manufacturing',
              'Process of research',
              'Process of designing products'
            ],
            'answer': 'Process of promoting products'
          },
          {
            'question': 'Which of these is part of the 4Ps of marketing?',
            'options': ['Product', 'Purpose', 'Payment', 'People'],
            'answer': 'Product'
          },
          {
            'question': 'What is a target market?',
            'options': [
              'A specific group of customers',
              'All possible customers',
              'Global audience',
              'Competitors'
            ],
            'answer': 'A specific group of customers'
          },
          {
            'question': 'What does branding mean?',
            'options': [
              'Creating a unique identity',
              'Setting a low price',
              'Manufacturing products',
              'Training employees'
            ],
            'answer': 'Creating a unique identity'
          },
          {
            'question': 'What is a market segment?',
            'options': [
              'A group with similar needs',
              'A type of advertisement',
              'A business strategy',
              'A pricing model'
            ],
            'answer': 'A group with similar needs'
          }
        ]
      },
      {
        'title': 'Quiz 2: Market Research',
        'questions': [
          {
            'question': 'What is primary research?',
            'options': [
              'Research collected firsthand',
              'Research done on the internet',
              'Research from competitors',
              'Research for employees'
            ],
            'answer': 'Research collected firsthand'
          },
          {
            'question': 'What is a survey?',
            'options': [
              'A questionnaire to collect data',
              'A type of product',
              'An advertisement',
              'A financial report'
            ],
            'answer': 'A questionnaire to collect data'
          },
          {
            'question': 'What is a focus group?',
            'options': [
              'A small group discussing a topic',
              'A type of product line',
              'A section of market',
              'An online ad campaign'
            ],
            'answer': 'A small group discussing a topic'
          },
          {
            'question': 'What is a SWOT analysis?',
            'options': [
              'Tool analyzing strengths, weaknesses, opportunities, and threats',
              'Financial model',
              'Pricing strategy',
              'Customer database'
            ],
            'answer':
                'Tool analyzing strengths, weaknesses, opportunities, and threats'
          },
          {
            'question': 'What is secondary research?',
            'options': [
              'Using already available data',
              'Conducting new interviews',
              'Holding focus groups',
              'Surveying customers'
            ],
            'answer': 'Using already available data'
          }
        ]
      },
      {
        'title': 'Quiz 3: Digital Marketing',
        'questions': [
          {
            'question': 'What is digital marketing?',
            'options': [
              'Marketing using digital channels',
              'Marketing using traditional methods',
              'Outdoor advertising',
              'Public relations'
            ],
            'answer': 'Marketing using digital channels'
          },
          {
            'question': 'What is SEO?',
            'options': [
              'Search Engine Optimization',
              'Sales Engagement Online',
              'Service Engagement Online',
              'Social Engagement Optimization'
            ],
            'answer': 'Search Engine Optimization'
          },
          {
            'question': 'What does PPC stand for?',
            'options': [
              'Pay Per Click',
              'Private Product Cost',
              'Public Product Campaign',
              'Public Pricing Conversion'
            ],
            'answer': 'Pay Per Click'
          },
          {
            'question': 'What is content marketing?',
            'options': [
              'Creating valuable content',
              'Only paid ads',
              'Social media management',
              'Direct selling'
            ],
            'answer': 'Creating valuable content'
          },
          {
            'question': 'What is influencer marketing?',
            'options': [
              'Using popular figures to promote',
              'Focusing only on top sales',
              'Creating ads',
              'Hiring celebrities for events'
            ],
            'answer': 'Using popular figures to promote'
          }
        ]
      },
    ]
  },
];

List<Map<String, dynamic>> get lCourses => _courses;

final List<Course> dbCourses =
    _courses.map((json) => Course.fromJson(json)).toList();
