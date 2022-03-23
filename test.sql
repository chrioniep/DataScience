SELECT artists.name, artists.lastName FROM artists
JOIN songs
ON songs.artist = artists.id
WHERE songs.id = "id de la chanson que tu cherche"




// album
id
title

// song
name
artist
album