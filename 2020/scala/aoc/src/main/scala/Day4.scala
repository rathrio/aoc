import scala.io.Source
import scala.util.matching.Regex

trait Validator {
  def validate(input: String): Boolean
}

case class Range(min: Int, max: Int) extends Validator {
  override def validate(input: String): Boolean = {
    val number = input.toInt
    number >= min && number <= max
  }
}

case class Enum(values: List[String]) extends Validator {
  override def validate(input: String): Boolean = {
    values.contains(input)
  }
}

case class Pattern(pattern: Regex) extends Validator {
  override def validate(input: String): Boolean = pattern.matches(input)
}

object Day4 extends App {
  val DATA_PATTERN = "\\S+:\\S+".r

  type Passport = Map[String, String]

  val REQUIRED_FIELDS: Map[String, Validator] = Map(
    "byr" -> Range(1920, 2002),
    "iyr" -> Range(2010, 2020),
    "eyr" -> Range(2020, 2030),
    "hgt" -> Pattern("^\\d+(cm|in)$".r),
    "hcl" -> Pattern("^#\\w{6}$".r),
    "ecl" -> Enum(List("amb", "blu", "brn", "gry", "grn", "hzl", "oth")),
    "pid" -> Pattern("^\\d{9}$".r)
  )

  val OPTIONAL_FIELDS = Set(
    "cid"
  )

  def contents(): String = {
    val source = Source.fromFile("src/main/resources/Day4.invalid.txt")
    val str = source.mkString
    source.close()
    str
  }

  def passportStrings(): Array[String] = {
    contents().split("\n\n")
  }

  def parsePassport(str: String): Passport = {
    DATA_PATTERN.findAllIn(str)
      .map(_.split(":"))
      .map(pair => Tuple2(pair(0), pair(1)))
      .toMap
  }

  def passports(): Array[Passport] = {
    passportStrings().map(parsePassport)
  }

  def hasRequiredFields(passport: Passport): Boolean = {
    val diff = REQUIRED_FIELDS.keySet.diff(passport.keySet)
    diff.isEmpty || diff == OPTIONAL_FIELDS
  }

  def hasValidValues(passport: Passport): Boolean = {
    if (!hasRequiredFields(passport)) {
      return false
    }

    passport.forall { case (field, value) =>
      if (OPTIONAL_FIELDS.contains(field)) {
        return true
      }

      val validator = REQUIRED_FIELDS(field)
      validator.validate(value)
    }
  }

  def part1() = {
    passports().count(hasRequiredFields)
  }

  def part2() = {
    passports().count(hasValidValues)
  }

  println("Part 1: " + part1())
  println("Part 2: " + part2())
}
