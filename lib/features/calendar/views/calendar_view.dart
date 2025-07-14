import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CalendarView extends ConsumerStatefulWidget {
  const CalendarView({super.key});

  @override
  ConsumerState<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends ConsumerState<CalendarView> {
  DateTime _focusedMonth = DateTime.now();

  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: _previousMonth,
          ),
          Text(
            DateFormat.yMMMM().format(_focusedMonth),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: _nextMonth,
          ),
        ],
      ),
    );
  }

  Widget _buildDaysOfWeek() {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:
          days
              .map(
                (day) => Text(
                  day,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )
              .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final firstDayOfMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      1,
    );
    final startingWeekday =
        firstDayOfMonth.weekday % 7; // Sunday is 7, so we mod by 7 to make it 0

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemCount: daysInMonth + startingWeekday,
      itemBuilder: (context, index) {
        if (index < startingWeekday) {
          return Container(); // Empty cell
        }
        final day = index - startingWeekday + 1;
        final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
        final isToday =
            date.year == DateTime.now().year &&
            date.month == DateTime.now().month &&
            date.day == DateTime.now().day;

        return Container(
          margin: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: AssetImage("assets/images/Samekosaba.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Text(
            '$day',
            style: TextStyle(color: isToday ? Colors.green : Colors.black),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calendar"), centerTitle: true),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 10),
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              _previousMonth();
            } else if (details.primaryVelocity! < 0) {
              _nextMonth();
            }
          },
          child: Column(
            children: [
              _buildHeader(),
              _buildDaysOfWeek(),
              _buildCalendarGrid(),
            ],
          ),
        ),
      ),
    );
  }
}
