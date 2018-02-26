module Main where

-- 1. Setup library code

data Contact gdpr
  = Contact
      { contactId :: Integer
      , contactName :: String
      , contactEmail :: String
      }
  deriving (Show, Eq)

data PossiblyEU
data NonEU

possiblyEUContact
  :: Integer -- ^ ID
  -> String  -- ^ Name
  -> String  -- ^ Email
  -> Contact PossiblyEU
possiblyEUContact id' name email =
  Contact
    { contactId = id'
    , contactName = name
    , contactEmail = email
    }

nonEUContact
  :: Integer -- ^ ID
  -> String  -- ^ Name
  -> String  -- ^ Email
  -> Contact NonEU
nonEUContact id' name email =
  Contact
    { contactId = id'
    , contactName = name
    , contactEmail = email
    }

getContacts :: IO [Contact PossiblyEU]
getContacts =
  pure
    [ possiblyEUContact 1  "John Oldman"          "lastmanstanding@example.com"
    , possiblyEUContact 2  "Florence Nightingale" "florence@example.edu"
    , possiblyEUContact 3  "Leonardo da Vinci"    "leo.io@example.com"
    , possiblyEUContact 4  "George Orwell"        "1984@example.com"
    , possiblyEUContact 5  "Marie Curie"          "nofearcurie@example.com"
    , possiblyEUContact 6  "René Descartes"       "cogitoergosum@example.com"
    , possiblyEUContact 7  "Alonzo Church"        "lambdalambdalambda@example.edu"
    , possiblyEUContact 8  "Donald Trump"         "lol@example.org"
    , possiblyEUContact 9  "Dexter Morgan"        "iamthepolice@example.org"
    , possiblyEUContact 10 "Cathy Newman"         "soyouresaying@example.com"
    ]

getNonEUContacts :: IO [Contact NonEU]
getNonEUContacts =
  pure
    [ nonEUContact 1 "John Oldman"   "lastmanstanding@example.com"
    , nonEUContact 7 "Alonzo Church" "lambdalambdalambda@example.edu"
    , nonEUContact 8 "Donald Trump"  "lol@example.org"
    , nonEUContact 9 "Dexter Morgan" "iamthepolice@example.org"
    ]

data Email
  = Email
      { to :: String
      , subject :: String
      , body :: String
      }

deliver :: Email -> IO ()
deliver _ = pure ()

marketingEmail :: Contact NonEU -> Email
marketingEmail contact =
  Email
    { to = contactEmail contact
    , subject = "Check out our newest product!"
    , body = "Hey " ++ contactName contact ++ ",\n\n\
             \Buy, buy, buy!\n\n\

             \We shall be sure to send you another reminder after you've \
             \purchased the product and been forced to enter your email, \
             \despite the fact that we already have it on hand in, like, \
             \a hundred replicated databases.\n\n\

             \Cheers,\n\
             \Evil Corp"
    }

sendMarketingEmail :: Contact NonEU -> IO ()
sendMarketingEmail =
  deliver . marketingEmail

-- 2. Setup application code

sendMarketingEmails :: [Contact NonEU] -> IO ()
sendMarketingEmails contacts =
  mapM_ sendMarketingEmail contacts

-- 3. Execute application code

main :: IO ()
main = do
  contacts <- getContacts
  sendMarketingEmails contacts
