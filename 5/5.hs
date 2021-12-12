import System.IO
    ( hClose, openFile, hGetContents, IOMode(ReadMode) )
import Text.Parsec
import Text.Parsec.String
import Control.Monad
import Data.List
import Data.Maybe
import Data.Sequence (replicate, Seq, mapWithIndex)

import Data.Map (Map, (!))
import qualified Data.Map as Map

type Coord     = (Int, Int)
type LineEnds  = (Coord, Coord)

type Grid       = Map Coord Integer

int :: Parser Int
int = read <$> many1 digit

eol :: Parser ()
eol = void $ char '\n'

coord :: Parser Coord
coord = do
    x <- int
    char ','
    y <- int

    return (x, y)

arrow :: Parser ()
arrow = void $ string " -> "

line :: Parser LineEnds
line = do
    from <- coord
    arrow
    to <- coord

    return (from, to)

inputParser :: Parser [LineEnds]
inputParser = line `endBy1` eol

lineToCellList :: LineEnds -> [Coord]
lineToCellList ((x0, y0), (x1, y1))
    | x0 == x1  = [ (x0, y) | y <- [min y0 y1 .. max y0 y1] ]
    | y0 == y1  = [ (x, y0) | x <- [min x0 x1 .. max x0 x1] ]
    | otherwise = [ (x, y)  | x <- [min x0 x1 .. max x0 x1],
                              y <- [min y0 y1 .. max y0 y1],
                              abs (x - x0) == abs (y - y0) ]

type CoordMap = Map Coord Int

scoreFold :: Coord -> (CoordMap, Int) -> (CoordMap, Int)
scoreFold coord (map, acc) 
    | Map.member coord map = if
        (map ! coord) == 1 then (Map.adjust (+1) coord map, acc + 1)
        else                    (Map.adjust (+1) coord map, acc)
    | otherwise            = (Map.insert coord 1 map, acc)

score :: [LineEnds] -> Int
score les = snd (foldr scoreFold (Map.empty, 0) coords)
    where
        coords = concatMap lineToCellList les

main = do
    handle <- openFile "input.txt" ReadMode
    contents <- hGetContents handle
    case parse inputParser "" contents of
        Left x -> print x
        Right x -> print (score x)
    hClose handle
