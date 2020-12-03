import scala.io.Source

class PasswordSpec(val min: Int, val max: Int, val char: String) {
  def validate1(password: String): Boolean = {
    val charCount = password.toList.count(_ == char.charAt(0))
    charCount >= min && charCount <= max
  }

  def validate2(password: String): Boolean = {
    List(min, max)
      .map(index => password.charAt(index - 1))
      .count(_ == char.charAt(0)) == 1
  }
}

object PasswordSpec {
  /**
   * @param str "2-9 c"
   */
  def fromSpecStr(str: String) = {
    val Array(range, char) = str.split(" ")
    val Array(min, max) = range.split("-").map(s => s.toInt)
    new PasswordSpec(min, max, char)
  }
}

object Day2 extends App {
  def lines(): List[String] = {
    val source = Source.fromFile("src/main/resources/Day2.txt")
    val lines = source.getLines().toList
    source.close()
    lines
  }

  def part1(): Int = {
    lines().count { line: String =>
      val Array(specString, password) = line.split(": ")
      val spec = PasswordSpec.fromSpecStr(specString)
      spec.validate1(password)
    }
  }

  def part2(): Int = {
    lines().count { line: String =>
      val Array(specString, password) = line.split(": ")
      val spec = PasswordSpec.fromSpecStr(specString)
      spec.validate2(password)
    }
  }

  println("Part 1: " + part1())
  println("Part 2: " + part2())
}
