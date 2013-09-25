{-# LANGUAGE OverloadedStrings #-}

-- warp
-- blaze-html
-- utf8-string\

import Network.Wai
import Network.HTTP.Types (status200)
import Network.Wai.Handler.Warp (run)
import Blaze.ByteString.Builder (copyByteString)
import qualified Data.ByteString.UTF8 as BU
import Data.Monoid
import qualified Data.Text as DT

main :: IO()
main = run 3000 simpelSite

simpelSite req = return $ 
				case pathInfo req of
					["gaaf"] -> gaaf
					x -> input x
  
--Responses:
welkom :: Response
welkom = ResponseBuilder status200 [("Content-Type", "text/plain")] $ copyByteString "hoi!, je moet voor de grap eens ###. \n\nGroetjes!"

gaaf :: Response
gaaf = ResponseBuilder status200 [("Content-Type", "text/plain")] $ copyByteString "Een linkje, gaaf!"

-- [DT.Text] is een lijst van alle dingen gescheiden door een / in de url param bijv: .com/hoi/2/dingen/appel banaan/ -> ["hoi", "2", "dingen", "appel banaan"]
input :: [DT.Text] -> Response
input []	= welkom
input x 	= ResponseBuilder 
				status200 
				[("Content-Type", "text/plain")] 
				$ mconcat $ map copyByteString ["je typte ", BU.fromString $ DT.unpack $ DT.intercalate " " x ]