{-# LANGUAGE OverloadedStrings #-}

-- Deze proof of concept serveert zowel via http (op poort 8000) als websockets (8080) content. 
-- De HTTP-server serveert een pagina die verbinding maakt met de websockets server

-- Nodige cabal packages
-- websockets
-- warp
-- blaze-html
-- utf8-string

import qualified Network.WebSockets as WS
import Control.Monad (forever)
import qualified Data.Text as T

import qualified Network.Wai as WAI
import Network.HTTP.Types (status200)
import qualified Network.Wai.Handler.Warp as WRP (run)
import qualified Blaze.ByteString.Builder as BL (copyByteString)
import Data.Monoid
import qualified Data.ByteString.UTF8 as BU
import Control.Concurrent (forkIO)

main :: IO ()
main = do
		forkIO serverHttp
		WS.runServer "0.0.0.0" 8080 websockets --runserver is een extreem simpele server voor de websockets
		
		
serverHttp :: IO ()
serverHttp = do
				staticContent <- readFile "websocketstest.html"
				WRP.run 8000 (httpget staticContent)
				return ()

--	HTTP GET
httpget :: String -> WAI.Application
httpget a req = return $ do 
				WAI.ResponseBuilder status200 [("Content-Type", "text/html")] $ BL.copyByteString $ BU.fromString a
		
--	WEBSOCKETS			
-- RFC6455 heeft de beste browsersupport, zie ook: http://en.wikipedia.org/wiki/WebSocket#Browser_support
-- zit om een vage reden niet in SebSockets (ondanks dat doc zegt van wel), Hybi00 werkt iig in IE11 en Chrome 29
websockets :: WS.Request -> WS.WebSockets WS.Hybi00 ()
websockets rq = do
					WS.acceptRequest rq
					WS.sendTextData $ T.pack "Hallo client, wat wil je met 3 vermenigvuldigen?"
					vermenigvuldig
					
vermenigvuldig :: WS.WebSockets WS.Hybi00 ()
vermenigvuldig = forever $ do
					msg <- WS.receiveData
					WS.sendTextData $ resultaat ((read $ T.unpack msg)::Int)
					
resultaat :: Int -> T.Text
resultaat 0 = "0 keer iets is 0, dat weet toch iedereen mallerd"
resultaat x = T.pack $ show $ x*3	