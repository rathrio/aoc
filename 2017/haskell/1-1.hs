import System.Environment
import System.Exit

main = do
  (digits:_) <- getArgs
  print digits
