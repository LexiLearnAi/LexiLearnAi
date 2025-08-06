import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lexilearnai/core/config/theme/app_color_scheme.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatelessWidget {
  const CustomCalendar(
      {super.key,
      required this.focusedDay,
      required this.firstDay,
      required this.lastDay,
      required this.onDaySelected});
  final DateTime focusedDay;
  final DateTime firstDay;
  final DateTime lastDay;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return TableCalendar(
      focusedDay: focusedDay,
      firstDay: firstDay,
      lastDay: lastDay,
      onDaySelected: onDaySelected,
      currentDay: focusedDay,
      rowHeight: size.height * 0.1,
      selectedDayPredicate: (day) {
        return isSameDay(focusedDay, day);
      },
      headerStyle: HeaderStyle(
        titleTextFormatter: (date, locale) {
          return DateFormat("MMMM yyyy").format(date);
        },
        titleTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
            ),
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronMargin: EdgeInsets.only(left: size.width * 0.15),
        rightChevronMargin: EdgeInsets.only(right: size.width * 0.15),
      ),
      daysOfWeekVisible: false,
      calendarFormat: CalendarFormat.week,
      calendarBuilders: CalendarBuilders(
        disabledBuilder: (context, day, focusedDay) {
          return _buildDayContainer(size, day, context, Colors.grey, true);
        },
        defaultBuilder: (context, day, focusedDay) =>
            _buildDayContainer(size, day, context, Colors.black, false),
        outsideBuilder: (context, day, focusedDay) {
          return _buildDayContainer(size, day, context, Colors.black, false);
        },
        selectedBuilder: (context, day, focusedDay) =>
            _selectedBuilderContainer(day, context, size),
      ),
    );
  }

  Widget _selectedBuilderContainer(
      DateTime day, BuildContext context, Size size) {
    final formattedDay = DateFormat("E").format(day);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(18)),
            color: AppColorScheme.lightColorScheme.primary,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(formattedDay,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              Text(day.day.toString(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDayContainer(Size size, DateTime day, BuildContext context,
      Color textColor, bool isDisabled) {
    final formattedDay = DateFormat("E").format(day);
    final dayString = day.day.toString();
    return Container(
      margin: isDisabled
          ? EdgeInsets.symmetric(horizontal: size.width * 0.01)
          : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            formattedDay,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: textColor),
          ),
          Text(
            dayString,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
