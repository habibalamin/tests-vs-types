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

getContacts :: IO [Contact PossiblyEU]
getContacts =
  pure
    [ Contact
        { contactId = 1
        , contactName = "John Oldman"
        , contactEmail = "lastmanstanding@example.com"
        }
    , Contact
        { contactId = 2
        , contactName = "Florence Nightingale"
        , contactEmail = "florence@example.edu"
        }
    , Contact
        { contactId = 3
        , contactName = "Leonardo da Vinci"
        , contactEmail = "leo.io@example.com"
        }
    , Contact
        { contactId = 4
        , contactName = "George Orwell"
        , contactEmail = "1984@example.com"
        }
    , Contact
        { contactId = 5
        , contactName = "Marie Curie"
        , contactEmail = "nofearcurie@example.com"
        }
    , Contact
        { contactId = 6
        , contactName = "René Descartes"
        , contactEmail = "cogitoergosum@example.com"
        }
    , Contact
        { contactId = 7
        , contactName = "Alonzo Church"
        , contactEmail = "lambdalambdalambda@example.edu"
        }
    , Contact
        { contactId = 8
        , contactName = "Donald Trump"
        , contactEmail = "lol@example.org"
        }
    , Contact
        { contactId = 9
        , contactName = "Dexter Morgan"
        , contactEmail = "iamthepolice@example.org"
        }
    , Contact
        { contactId = 10
        , contactName = "Cathy Newman"
        , contactEmail = "soyouresaying@example.com"
        }
    ]

getNonEUContacts :: IO [Contact NonEU]
getNonEUContacts =
  pure
    [ Contact
        { contactId = 1
        , contactName = "John Oldman"
        , contactEmail = "lastmanstanding@example.com"
        }
    , Contact
        { contactId = 7
        , contactName = "Alonzo Church"
        , contactEmail = "lambdalambdalambda@example.edu"
        }
    , Contact
        { contactId = 8
        , contactName = "Donald Trump"
        , contactEmail = "lol@example.org"
        }
    , Contact
        { contactId = 9
        , contactName = "Dexter Morgan"
        , contactEmail = "iamthepolice@example.org"
        }
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
