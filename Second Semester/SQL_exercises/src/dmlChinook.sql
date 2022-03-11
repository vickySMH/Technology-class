USE chinook;

# 1. How many songs are there in the playlist “Grunge”?
SELECT COUNT(track.Name) FROM playlist, playlisttrack, track
WHERE playlist.Name = 'Grunge'
  AND track.TrackId = playlisttrack.TrackID
  AND playlisttrack.PlaylistId = playlist.PlaylistId;

# 2. Show information about artists whose name includes the text “Jack”
# and about artists whose name includes the text “John”, but not the text “Martin”.
SELECT * FROM artist
WHERE Name LIKE '%Jack%'
UNION
SELECT * FROM artist
WHERE Name LIKE '%John%'
  AND Name NOT LIKE '%Martin%';

SELECT * FROM artist
WHERE Name LIKE '%Jack%'
   OR Name LIKE '%John%'
    AND Name NOT LIKE '%Martin%';


# 3. For each country where some invoice has been issued, show the total invoice
# monetary amount, but only for countries where at least $100 have been invoiced.
# Sort the information from higher to lower monetary amount.
SELECT SUM(Total) AS 'Country total' FROM Invoice
GROUP BY BillingCountry HAVING SUM(Total) >= 100
ORDER BY 'Country total' DESC;

# 4. Get the phone number of the boss of those employees who have given support to clients
# who have bought some song composed by “Miles Davis” in “MPEG Audio File” format.
SELECT DISTINCT e2.Phone FROM employee
                                  INNER JOIN employee e2 on employee.ReportsTo = e2.EmployeeId, customer, invoice, artist, mediatype
WHERE MediaTypeId = 1
  AND artist.Name = 'Miles Davis'
  AND invoice.CustomerId = customer.CustomerId
  AND customer.SupportRepId = employee.EmployeeId;

# 5. Show the information, without repeated records, of all albums that feature songs of the “Bossa Nova”
# genre whose title starts by the word “Samba”.
SELECT DISTINCT album.AlbumId, Title, ArtistId FROM album, track, genre
WHERE track.GenreId = Genre.GenreId
  AND genre.Name = 'Bossa Nova'
  AND track.AlbumId = Album.AlbumId
  AND track.Name LIKE 'Samba%';

# 6. For each genre, show the average length of its songs in minutes (without indicating seconds).
# Use the headers “Genre” and “Minutes”, and include only genres that have any song longer than half an hour.
SELECT Genre.Name AS 'Genre',
       TRUNCATE(AVG(Milliseconds/60000), 0) AS 'Minutes'
FROM Track, Genre WHERE Milliseconds/60000 > 30
                    AND Genre.GenreId = Track.GenreId
GROUP BY Genre;

# 7. How many client companies have no state?
SELECT DISTINCT COUNT(Company) FROM customer
WHERE State IS NULL
  AND Company IS NOT NULL;

# 8. For each employee with clients in the “USA”, “Canada” and “Mexico” show the number of clients
# from these countries s/he has given support, only when this number is higher than 6.
# Sort the query by number of clients. Regarding the employee, show his/her first name
# and surname separated by a space. Use “Employee” and “Clients” as headers.
SELECT CONCAT(Employee.FirstName,' ', Employee.LastName) AS 'Employee',
       COUNT(SupportRepId) AS 'Client' FROM Employee
                                                LEFT JOIN Customer C on Employee.EmployeeId = C.SupportRepId
WHERE C.Country = 'USA' OR C.Country = 'Canada' OR C.Country = 'Mexico'
GROUP BY Employee HAVING Client > 6;

# 9. For each client from the “USA”, show his/her surname and name (concatenated and separated
# by a comma) and their fax number. If they do not have a fax number, show the text
# “S/he has no fax”. Sort by surname and first name.
SELECT CONCAT(LastName, ', ', FirstName) AS 'FullName',
       IFNULL(Fax, 'S/he has no fax') AS FAX FROM Customer
WHERE Country = 'USA' ORDER BY LastName ASC;

# 10. For each employee, show his/her first name, last name, and their age at the time they were hired.
SELECT FirstName, LastName, TIMESTAMPDIFF(YEAR, BirthDate, HireDate) AS age
FROM employee;
