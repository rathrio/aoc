import scala.io.Source

object Day3 extends App {
  def lines(): List[String] = {
    val source = Source.fromFile("src/main/resources/Day3.txt")
    val lines = source.getLines().toList
    source.close()
    lines
  }

  def grid() = {
    lines().map(line => line.split(""))
  }

  def treesInSlope(grid: List[Array[String]], move: (Int, Int)): Int = {
    val (right, down) = move
    var numTrees = 0
    var colIndex = right
    var rowIndex = down

    var row = grid(rowIndex)
    while (true) {
      val location = row(colIndex % row.length)
      if (location == "#") {
        numTrees += 1
      }

      colIndex += right
      rowIndex += down

      if (rowIndex >= grid.length) {
        return numTrees
      }

      row = grid(rowIndex)
    }

    -1
  }

  def part1() = {
    treesInSlope(grid(), (3, 1))
  }

  def part2() = {
    val g = grid()
    List(
      (1, 1),
      (3, 1),
      (5, 1),
      (7, 1),
      (1, 2)
    ).map(treesInSlope(g, _).toLong).product
  }

  println("Part 1: " + part1())
  println("Part 2: " + part2())
}
