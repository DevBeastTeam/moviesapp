import 'package:flutter/material.dart';

class LessonTimelineWidget extends StatelessWidget {
  final List<LessonModel> lessons;
  final Function(int index, LessonModel lesson) onLessonTap;

  const LessonTimelineWidget({
    super.key,
    required this.lessons,
    required this.onLessonTap,
  });

  Widget _buildLessonCard(
    BuildContext context,
    LessonModel lesson,
    bool isLeft,
    int index,
  ) {
    final bool isCompleted = lesson.isCompleted;

    final Color cardColor = isCompleted
        ? Colors.lightGreenAccent.shade100
        : Colors.redAccent.shade100;

    final Color titleColor = isCompleted
        ? Colors.green.shade900
        : Colors.red.shade900;

    final Color subtitleColor = isCompleted
        ? Colors.green.shade700
        : Colors.red.shade700;

    return GestureDetector(
      onTap: () => onLessonTap(index, lesson),
      child: Row(
        mainAxisAlignment: isLeft
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          if (!isLeft) const Spacer(),
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  lesson.subtitle,
                  style: TextStyle(fontSize: 15, color: subtitleColor),
                ),
              ],
            ),
          ),
          if (isLeft) const Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int totalLessons = lessons.length;
    final int completedLessons = lessons
        .where((lesson) => lesson.isCompleted)
        .length;

    final double progressRatio = totalLessons > 0
        ? completedLessons / totalLessons
        : 0;

    return Stack(
      children: [
        // 🔸 Vertical progress line
        LayoutBuilder(
          builder: (context, constraints) {
            final lineHeight = constraints.maxHeight * progressRatio;
            return Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 8,
                margin: const EdgeInsets.symmetric(vertical: 40),
                height: constraints.maxHeight,
                child: Stack(
                  children: [
                    // Background faint line
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // Progress gradient line
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: lineHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFFA726),
                              Color(0xFFFF7043),
                              Color(0xFFF44336),
                              // Color(0xFFE91E63),
                              // Color(0xFF9C27B0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orangeAccent.withOpacity(0.6),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // 🔹 Lessons list
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              children: List.generate(lessons.length, (index) {
                final lesson = lessons[index];
                final isLeft = index.isEven;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: _buildLessonCard(context, lesson, isLeft, index),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

class LessonModel {
  final String title;
  final String subtitle;
  final bool isCompleted;

  LessonModel({
    required this.title,
    required this.subtitle,
    this.isCompleted = false,
  });
}
