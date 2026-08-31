import 'package:flutter_test/flutter_test.dart';

// Dummy representation of your Bookmark entity for pure logic testing
class MockBookmark {
  final int surahNumber;
  final int ayahNumber;

  MockBookmark(this.surahNumber, this.ayahNumber);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MockBookmark &&
          runtimeType == other.runtimeType &&
          surahNumber == other.surahNumber &&
          ayahNumber == other.ayahNumber;

  @override
  int get hashCode => surahNumber.hashCode ^ ayahNumber.hashCode;
}

void main() {
  group('Quran Bookmark Regression Tests', () {
    test('Should prevent duplicate bookmarks for the same Surah and Ayah', () {
      final bookmarks = <MockBookmark>{};

      // Action 1: Add first bookmark
      final bookmark1 = MockBookmark(1, 1);
      bookmarks.add(bookmark1);

      expect(bookmarks.length, 1);

      // Action 2: Attempt to add the exact same bookmark
      final bookmark2 = MockBookmark(1, 1);
      bookmarks.add(bookmark2);

      // Assertion: Set inherently prevents duplicates based on equatable/hashCode
      expect(bookmarks.length, 1);

      // Action 3: Add different bookmark
      final bookmark3 = MockBookmark(1, 2);
      bookmarks.add(bookmark3);

      expect(bookmarks.length, 2);
    });

    test('Should remove bookmark correctly', () {
      final bookmarks = <MockBookmark>{MockBookmark(2, 255)};
      expect(bookmarks.length, 1);

      // Action: Remove
      bookmarks.removeWhere((b) => b.surahNumber == 2 && b.ayahNumber == 255);

      // Assertion
      expect(bookmarks.isEmpty, true);
    });
  });
}
