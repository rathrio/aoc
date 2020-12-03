import scala.io.Source

object Day1 extends App {
  def lines() = {
    val source = Source.fromFile("src/main/resources/Day1.txt")
    val lines = source.getLines().toList
    source.close()
    lines
  }

  def entries(): List[Int] = lines().map(n => n.toInt)

  def isSum2020(entries: List[Int]): Boolean = entries.sum == 2020

  def productOf2020Combinations(n: Int): Int = {
    val combinations = entries().combinations(n)
    val combination = combinations.find(isSum2020).get
    combination.product
  }

  def part1(): Int = {
    productOf2020Combinations(2)
  }

  def part2(): Int = {
    productOf2020Combinations(3)
  }

  println("Part 1: " + part1())
  println("Part 2: " + part2())
}
