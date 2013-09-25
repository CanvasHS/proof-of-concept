{-# LANGUAGE OverloadedStrings #-}

-- websockets

import qualified Network.WebSockets as WS
import Control.Monad (forever)
import qualified Data.Text as T
import qualified Data.Text.IO as T

main :: IO ()
main = WS.runServer "0.0.0.0" 3000 app --runserver is een extreem simpele blockende server, later vervangen

-- Hybi00() ondersteunt het verzenden van tekst, ruim genoeg voor ons
app :: WS.Request -> WS.WebSockets WS.Hybi00 ()
app rq = do
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