# School Feedback Management System

![Thumbnial](https://github.com/user-attachments/assets/f3ff3e5c-1736-4f69-bb13-427cab87b294)



A Cross Platfrom Mobile application Developed for School Feedback Management with separate login and signup for faculty and students. 
Built with Flutter and Supabase for secure backend services.

## Features

- **Role-Based Authentication**: Separate login and signup for faculty and students.
- **Department-Segregated Feedback**: Collect and manage feedback by department.
- **Real-Time Data Management**: Synchronize and handle feedback data using Supabase.
- **Responsive Design**: User-friendly interface across mobile and tablet devices using Flutter.

## Tech Stack

- **Flutter**: For building the mobile application.
- **Dart**: Programming language used by Flutter.
- **Supabase**: For backend services, including authentication and real-time database management.

## Getting Started

### Prerequisites

- Flutter SDK installed
- Dart installed
- An editor like VS Code or Android Studio

### Installation

1. **Clone the repository:**

    ```bash
    git clone https://github.com/AayushPaigwar/school-feedback-system.git
    ```

2. **Navigate to the project directory:**

    ```bash
    cd school-feedback-management-system
    ```

3. **Install dependencies:**

    ```bash
    flutter pub get
    ```

4. **Run the project:**

    ```bash
    flutter run
    ```

## Project Structure

```
school-feedback-management-system
├── android
├── ios
├── lib
│   ├── backend
│   ├── components
│   │   ├── dropdown.dart
│   │   ├── select_dept.dart
│   │   ├── sized.dart
│   │   └── text_field.dart
│   ├── main.dart
│   ├── model
│   │   └── supabase_function.dart
│   ├── provider
│   │   └── provider_const.dart
│   └── screens
│       ├── feedback_fac.dart
│       ├── feedback_stu.dart
│       ├── signin
│       │   ├── signin_fac.dart
│       │   ├── signin_screen.dart
│       │   └── signin_stu.dart
│       ├── signup
│       │   └── signup_screen.dart
│       └── viewfeedback.dart
├── .gitignore
├── pubspec.yaml                 # Project dependencies
├── README.md                    # Project documentation
└── LICENSE                      # MIT License
```

## Contributing

Contributions are welcome! Feel free to submit a pull request or open an issue to improve the project.

## License

Distributed under the MIT License. See [LICENSE](LICENSE) for more information.

Happy coding! 🚀
