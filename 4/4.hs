import System.IO
import Text.Parsec
import Text.Parsec.String
import Control.Monad
import Data.List
import Data.Maybe

int :: Parser Int
int = read <$> many1 digit

eol :: Parser ()
eol = void $ char '\n'

draws :: Parser [Int]
draws = int `sepBy1` char ','

boardRow :: Parser [Int]
boardRow = do
    many (char ' ')
    int `sepBy1` many (char ' ')

board :: Parser [[Int]]
board = boardRow `endBy1` eol

boards :: Parser [[[Int]]]
boards = board `endBy1` (eol <|> eof)

inputParser :: Parser ([Int], [[[Int]]])
inputParser = do
    d <- draws
    eol
    eol
    b <- boards

    return (d, b)

checkRow :: [Int] -> [Int] -> Bool
checkRow row drawn = all (`elem` drawn) row

checkBoard :: [[Int]] -> [Int] -> Bool
checkBoard board drawn = any (`checkRow` drawn) board || any (`checkRow` drawn) (transpose board)

checkBoards :: [[[Int]]] -> [Int] -> [Bool]
checkBoards boards drawn = map (`checkBoard` drawn) boards

processTurns :: [[[Int]]] -> [Int] -> [[Bool]]
processTurns boards draws = map (checkBoards boards) turns
    where turns = [ take n draws | n <- [1 .. length draws ] ]


-- ret: (turn no, board win states)
getWinner :: [[[Int]]] -> [Int] -> (Int, Int)
getWinner boards draws = (turnNo, winnerIndex)
    where results     = processTurns boards draws
          turnNo      = fromJust (findIndex or results)
          boardStates = fromJust (find or results)
          winnerIndex = fromJust (elemIndex True boardStates)

getLoser :: [[[Int]]] -> [Int] -> (Int, Int)
getLoser boards draws = (turnNo, loserIndex)
    where results     = processTurns boards draws
          turnNo      = fromJust (findIndex and results)
          boardStates = results!!(turnNo - 1)
          loserIndex  = fromJust (elemIndex False boardStates)

getFinalDraw :: [Int] -> Int -> Int
getFinalDraw draws turnNo = draws!!turnNo

sumUnmarked :: [[Int]] -> [Int] -> Int
sumUnmarked board draws = sum filtered
    where filtered = [ x | xs <- board,
                           x <- xs,
                           x `notElem` draws ]

main = do
    handle <- openFile "input.txt" ReadMode
    contents <- hGetContents handle
    case parse inputParser "" contents of
        Left x -> print x
        Right (draws, boards) -> print (finalDraw, unmarkedSum, finalDraw * unmarkedSum,
                                        finalDrawLose, unmarkedSumLose, finalDrawLose * unmarkedSumLose)
            where (turnNo, winnerIndex)    = getWinner boards draws
                  finalDraw                = getFinalDraw draws turnNo
                  unmarkedSum              = sumUnmarked (boards!!winnerIndex) (take (turnNo + 1) draws)
                  (turnNoLose, loserIndex) = getLoser boards draws      
                  finalDrawLose            = getFinalDraw draws turnNoLose
                  unmarkedSumLose          = sumUnmarked (boards!!loserIndex) (take (turnNoLose + 1) draws)
    hClose handle
