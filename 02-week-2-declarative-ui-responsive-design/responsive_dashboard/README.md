# Week 2 - Declarative UI & Responsive Design

## Academic Overview Dashboard

This project was created as part of the Week 2 Flutter Mobile Programming course at **JTI Politeknik Negeri Malang**.

In this week, I learned about Flutter's declarative UI approach, how widgets are used to build an interface, how state affects the UI, and how to make an application responsive on different screen sizes.

For the practical project, I created a simple **Academic Overview Dashboard** that displays student information and several academic summaries. The dashboard also supports responsive layouts, light and dark themes, and basic accessibility features.

---

## 1. Project Overview

The application is designed as a simple academic dashboard for an Informatics Engineering student.

The main page contains:

* Student profile information
* Assignment summary
* Attendance percentage
* Portfolio status
* Current academic week
* Light and dark mode
* Responsive layout for different screen sizes
* Basic accessibility labels

The main goal of this project is not to create a complex academic system, but to practice how Flutter widgets work together and how a UI can adapt to different screen sizes.

---

## 2. Declarative UI in Flutter

One of the main concepts I learned in this week is **declarative UI**.

In a declarative approach, I describe what the interface should look like based on the current state of the application. I do not manually change every UI element when something changes.

For example, the application has a boolean state for the dark mode:

```dart
bool isDark = false;
```

When the user changes the dark mode switch, the value changes and Flutter rebuilds the UI using the new state.

The theme mode is controlled using:

```dart
themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
```

This helped me understand that in Flutter, the UI is closely connected to the current state of the application.

---

## 3. Widgets Used

This project uses several basic Flutter widgets, including:

* `StatelessWidget`
* `StatefulWidget`
* `MaterialApp`
* `Scaffold`
* `AppBar`
* `Container`
* `Row`
* `Column`
* `Expanded`
* `Card`
* `GridView`
* `LayoutBuilder`
* `SingleChildScrollView`
* `Semantics`
* `CupertinoSwitch`

Each widget has a different purpose, and the final interface is created by combining them together.

### StatelessWidget

I used `StatelessWidget` for components such as:

* `DashboardPage`
* `ProfileHeader`
* `InfoCard`

These widgets do not manage their own changing state. Their UI can be built from the values provided to them.

### StatefulWidget

I used `StatefulWidget` for `DashboardApp` because the application needs to manage the dark mode state.

The state is stored using:

```dart
bool isDark = false;
```

When the switch is pressed, the state is updated and the interface changes accordingly.

---

## 4. Responsive Design

The dashboard is designed to work on both narrow and wide screens.

To achieve this, I used `LayoutBuilder` to check the available screen width.

I defined a breakpoint:

```dart
const double kWideBreakpoint = 700.0;
```

The application uses one column when the available width is below 700 pixels and two columns when the width is 700 pixels or wider.

The logic is:

```dart
final columns =
    constraints.maxWidth >= kWideBreakpoint ? 2 : 1;
```

This means that the layout automatically changes depending on the available space.

### Narrow screen

On a smaller screen, the cards are displayed in one column:

```text
[ Assignments ]

[ Attendance ]

[ Portfolio ]

[ Current Week ]
```

This makes the information easier to read on mobile devices.

### Wide screen

On a wider screen, the cards are arranged into two columns:

```text
[ Assignments ]    [ Attendance ]

[ Portfolio   ]    [ Current Week ]
```

This makes better use of the available horizontal space.

---

## 5. Why I Used GridView

For the academic summary section, I used `GridView.count`.

The dashboard contains four information cards, so a grid layout is a natural choice for displaying them.

However, the number of columns is not fixed.

`LayoutBuilder` is used to decide how many columns are needed:

```text
Screen width
     |
     v
LayoutBuilder
     |
     +---- below 700 px ----> 1 column
     |
     +---- 700 px or more --> 2 columns
```

After the number of columns is determined, `GridView.count` arranges the cards accordingly.

I chose this approach because it is simple, readable, and easy to maintain for this type of dashboard.

---

## 6. Expanded and Layout Constraints

Another important concept from this project is the use of `Expanded`.

For example, the profile header contains an avatar and student information inside a `Row`.

The student information uses:

```dart
Expanded(
  child: Column(
    ...
  ),
)
```

The `Expanded` widget allows the text section to use the remaining horizontal space.

This is useful because the student's name is relatively long. Without proper constraints, text inside a `Row` can potentially cause an overflow.

The same concept is also used inside the information cards so that the card title and value can share the available space without causing layout problems.

---

## 7. Reusable InfoCard Widget

Instead of creating four separate card layouts, I created a reusable `InfoCard` widget.

The widget accepts three main values:

* `title`
* `value`
* `icon`

For example:

```dart
InfoCard(
  title: 'Assignments',
  value: '8',
  icon: Icons.assignment_outlined,
)
```

Another card can use the same widget:

```dart
InfoCard(
  title: 'Attendance',
  value: '92%',
  icon: Icons.calendar_month_outlined,
)
```

This makes the code shorter and more consistent.

If I want to change the design of all academic cards in the future, I only need to update the `InfoCard` widget instead of editing every card individually.

---

## 8. Theme and Dark Mode

The application uses **Material 3** through:

```dart
useMaterial3: true,
```

I created both light and dark themes.

The application starts in light mode, and the user can switch to dark mode using the switch in the AppBar.

The current theme is controlled by:

```dart
themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
```

I also tried to avoid hard-coding colors directly inside individual widgets.

For example, the `InfoCard` uses the current theme's `ColorScheme`:

```dart
final colorScheme = theme.colorScheme;
```

Then colors such as the primary container and primary text are taken from the active theme.

This makes the UI adapt more naturally when switching between light and dark mode.

---

## 9. Accessibility

I also added basic accessibility support using the `Semantics` widget.

For example, the dark mode switch has an accessibility label:

```dart
Semantics(
  label: 'Toggle dark mode',
  child: CupertinoSwitch(...),
)
```

The information cards also provide a meaningful description:

```dart
Semantics(
  label: '$title: $value',
  child: Card(...),
)
```

This helps accessibility tools and screen readers understand what each element represents.

Although this is still a simple project, adding semantic labels helped me understand that accessibility should also be considered when designing an interface.

---

# 10. AI Prompt Challenge

As part of the assignment, I compared different approaches for creating a responsive academic dashboard.

### Prompt Used

> Compare using GridView with a responsive column layout using LayoutBuilder for an academic dashboard containing four information cards. The dashboard should display one column on narrow screens and two columns on wide screens. Explain the advantages, disadvantages, responsiveness, maintainability, and potential overflow issues of each approach. Recommend the better approach for this project and explain why.

### Summary of the AI Output

The comparison showed that `GridView` is useful when several items need to be displayed in a structured grid.

On the other hand, `LayoutBuilder` is useful when the application needs to make layout decisions based on the available screen size.

For this project, these two approaches can actually work together rather than being treated as completely separate options.

`LayoutBuilder` can determine whether the screen should use one or two columns, while `GridView` can handle the arrangement of the cards.

### My Decision

I decided to use:

```text
LayoutBuilder + GridView.count
```

because this approach fits the requirements of the dashboard.

The main reasons are:

1. It makes the responsive breakpoint easy to understand.
2. It supports one-column and two-column layouts.
3. The code is relatively simple.
4. The layout can easily be adjusted in the future.
5. The same `InfoCard` component can be reused.
6. It makes better use of available space on wider screens.

I also verified the result by running the application at different screen sizes instead of relying only on the AI recommendation.

---

## 11. Understanding Overflow with Expanded

One of the things I paid attention to during development was possible overflow inside `Row`.

For example, the profile section contains:

```text
CircleAvatar + Student Information
```

If the available screen width becomes smaller, the text section needs to be able to adapt.

Using `Expanded` allows the text section to take the remaining available space.

This is especially important for the student name:

```text
Nasywa Qonita Ramadhani Han
```

because it is long enough that it could cause a layout problem if the available width was not handled properly.

This helped me understand that Flutter's layout system is based heavily on constraints.

---

# 12. Testing

I created widget tests to make sure the main functionality of the dashboard works as expected.

The tests cover:

### Narrow screen

The dashboard is rendered using a narrow screen size.

The test checks that all four information cards are present.

### Wide screen

The dashboard is rendered using a wider screen size.

The test checks that the four information cards are still present.

### Dark mode

The test checks that:

1. The `CupertinoSwitch` exists.
2. The initial value is `false`.
3. The switch can be tapped.
4. The value changes to `true`.

The test environment uses:

```dart
tester.view.physicalSize
```

to simulate different screen sizes.

---

# 13. Verification

After completing the implementation, I checked the project using Flutter's analysis and testing tools.

### Flutter Analyze

Command:

```bash
flutter analyze
```

Result:

```text
No issues found!
```

This means there were no analyzer issues remaining in the project.

### Flutter Test

Command:

```bash
flutter test
```

Result:

```text
All tests passed!
```

The widget tests passed successfully.

### Manual Verification

I also checked the application manually in several conditions:

* Narrow/mobile screen
* Wide/desktop screen
* Light mode
* Dark mode
* Different screen widths
* Text and card readability
* Responsive card arrangement

---

# 14. Screenshots

The following screenshots were taken to document the responsive behavior of the application.

## Narrow Layout

The narrow layout uses one column for the academic summary cards.

![Narrow Layout](screenshots/narrow.png)

## Wide Layout

The wide layout uses two columns to make better use of the available screen width.

![Wide Layout](screenshots/wide.png)

## Dark Mode

The dark mode version demonstrates that the dashboard remains readable after changing the application theme.

![Dark Mode](screenshots/dark-mode.png)

---

# 15. Project Structure

The main project structure is:

```text
responsive_dashboard/
│
├── lib/
│   └── main.dart
│
├── test/
│   └── widget_test.dart
│
├── screenshots/
│   ├── narrow.png
│   ├── wide.png
│   └── dark-mode.png
│
├── README.md
├── pubspec.yaml
└── ...
```

The `main.dart` file contains the application implementation, while `widget_test.dart` contains the widget tests.

The `screenshots` folder contains documentation of the responsive and dark mode layouts.

---

# 16. Reflection

### What did I learn about declarative UI?

I learned that Flutter's declarative UI approach means that the interface is described based on the current state of the application.

Instead of manually changing individual widgets, I can change the state and let Flutter rebuild the UI based on that state.

The dark mode feature helped me understand this concept more clearly because changing one boolean value can change the entire application's theme.

### Why is responsive design important?

Responsive design is important because an application may be used on different devices and screen sizes.

A layout that looks good on a laptop may not work well on a mobile phone if the layout is fixed.

By using `LayoutBuilder` and a breakpoint, the dashboard can adapt its card arrangement depending on the available width.

### Why are reusable widgets useful?

Reusable widgets help reduce duplicated code and make the application easier to maintain.

The `InfoCard` widget is a good example. Instead of creating four different card implementations, I can reuse the same widget and only change its title, value, and icon.

### What was the most challenging part?

The most challenging part for me was understanding how Flutter's layout constraints work, especially when using `Row`, `Column`, `Expanded`, and `GridView` together.

At first, it can be confusing to understand which widget controls the available space. After testing the layout at different screen sizes, I became more familiar with how Flutter handles constraints and responsive layouts.

### What would I improve in the future?

If I continue developing this dashboard, I would like to connect it to real academic data instead of using static values.

I could also add features such as:

* Assignment details
* Course schedules
* Upcoming deadlines
* Academic progress
* Attendance history
* Grade information
* Persistent theme preferences

This would make the dashboard more useful as a real student application instead of only being a practice project.

---

# 17. Conclusion

Through this project, I practiced the basic concepts of Flutter's declarative UI and responsive design.

The final application demonstrates how `StatelessWidget`, `StatefulWidget`, `Row`, `Column`, `Expanded`, `Container`, `GridView`, and `LayoutBuilder` can be combined to create a responsive interface.

I also learned that building a good UI is not only about making it look good. The application also needs to consider different screen sizes, accessibility, maintainability, and how the interface responds to changes in state.

Overall, this project helped me understand the basic workflow of building a responsive Flutter application and gave me a better foundation for developing more complex mobile applications in the following weeks.
