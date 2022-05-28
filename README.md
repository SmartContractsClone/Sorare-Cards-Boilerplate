# Sorare-Cards-Boilerplate
A boilerplate code to create NFT cards like Sorare. All the players and clubs data is stored in blockchain. A Card can be minted in form of ERC721 NFT token following openzeppelin standards.

---------------------------------------------------
DATA.SOL

- The smart contract contains the data of clubs and players to be required for minintg a card.
- All the players and clubs are mapped to their unique ID which corresponds to data related to player or card.
- Moderator can create and mint players and clubs. Users can fetch the data corresponds to the ID.

CARDS.SOL

- The ERC721 smart contract that mints the NFT cards which contains data for player, club, season, and the card type.
- Users will be able to mint cards only if player and club exists.
- Each card is unique NFT token with standard NFT functions.

---------------------------------------------------

Feel free to use this code or suggest an edit for the same.
