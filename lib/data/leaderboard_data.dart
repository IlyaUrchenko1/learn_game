class LeaderboardEntry {
  final String name;
  final int completedLevels;

  const LeaderboardEntry({required this.name, required this.completedLevels});
}

const List<LeaderboardEntry> leaderboardData = [
  LeaderboardEntry(name: 'Алекс', completedLevels: 15),
  LeaderboardEntry(name: 'Мария', completedLevels: 14),
  LeaderboardEntry(name: 'Иван', completedLevels: 12),
  LeaderboardEntry(name: 'Елена', completedLevels: 10),
  LeaderboardEntry(name: 'Дмитрий', completedLevels: 9),
  LeaderboardEntry(name: 'София', completedLevels: 7),
  LeaderboardEntry(name: 'Михаил', completedLevels: 5),
  LeaderboardEntry(name: 'Анна', completedLevels: 3),
  LeaderboardEntry(name: 'Никита', completedLevels: 2),
  LeaderboardEntry(name: 'Виктория', completedLevels: 1),
];
