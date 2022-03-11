USE library;

# 1. Show the members under the name "Jens S." who were born before 1970 that became members of the library in 2013.
SELECT * FROM tmember WHERE cName = 'Jens S.' AND YEAR(dBirth) < 1970 AND YEAR(dNewMember) = 2013;

# 2. Show those books that have not been published by the publishing companies with ID 15 and 32,
# except if they were published before 2000.
SELECT * FROM tbook WHERE nPublishingCompanyID NOT IN (15, 32) OR
                          (nPublishingCompanyID IN (15, 32) AND nPublishingYear < 2000);
-- not sure it works it misses some of the books published by company id 32 that are published before 2000

# 3. Show the name and surname of the members who have a phone number, but no address.
SELECT * FROM tmember WHERE cName IS NOT NULL AND cSurname IS NOT NULL AND cAddress IS NULL;

# 4. Show the authors with surname "Byatt" whose name starts by an "A" (uppercase) and contains an "S" (uppercase).
SELECT * FROM tauthor WHERE cSurname = 'Byatt' AND (cName LIKE 'A%' AND cName LIKE '%S%');

# 5. Show the number of books published in 2007 by the publishing company with ID 32.
SELECT COUNT(nBookID) FROM tbook WHERE nPublishingYear = 2007 AND nPublishingCompanyID = 32;

# 6. For each day of the year 2014, show the number of books loaned by the member with CPR "0305393207";
SELECT DAY(dLoan) AS day FROM tloan WHERE cCPR = '0305393207' AND YEAR(dLoan) = 2014
UNION
SELECT COUNT(cSignature) AS bookCount FROM tloan WHERE cCPR = '0305393207' AND YEAR(dLoan) = 2014;
    -- the last row shows how many books have been loaned and the above ones on which dates (if you don't change the order)

SELECT DAY(dLoan) AS day, COUNT(cSignature) AS book_count FROM tloan
WHERE cCPR = '0305393207' AND YEAR(dLoan) = 2014
GROUP BY DAY(dLoan);
    -- shows two columns: one for the day from 2014 and one with the number of books loaned then

SELECT COUNT(cSignature) FROM tloan WHERE cCPR = '0305393207' AND YEAR(dLoan) = 2014 ;
    -- shows one row with the number of books loaned by that member for the 2014


# 7. Modify the previous clause so that only those days where the member was loaned more than one book appear.
SELECT DAY(dLoan) AS day, COUNT(cSignature) AS loaned_books FROM tloan
WHERE cCPR = '0305393207' AND DAY(dLoan) > 1
GROUP BY DAY(dLoan);
-- shows also dates where only one book was loaned
-- actually shows how many books were loaned at the same day number but different month/year
-- first solution

SELECT DAY(dLoan) AS day, COUNT(cSignature) AS loaned_books FROM tloan
WHERE cCPR = '0305393207'
GROUP BY DAY(dLoan)
HAVING COUNT(cSignature) > 1;
-- doesn't show days where only one book was loaned and still doesn't order it by day
-- still shows for same day number but different month/year

SELECT * FROM tloan WHERE cCPR = '0305393207' IN (
    SELECT  cSignature FROM tloan
    GROUP BY cSignature
    HAVING COUNT(cSignature) > 1
    );
-- think this or below is correct
-- supposed to shows the dates when the member loaned more than one books on the same date
-- but checked the table and they never loaned more than one
-- this is the table where had the error about some columns and some of the info is missing
SELECT * FROM tloan WHERE cCPR = '0305393207' IN (
    SELECT  DAY(dLoan) FROM tloan
    GROUP BY dLoan
    HAVING DAY(dLoan) > 1);

# 8. Show all library members from the newest to the oldest. Those who became members on the same day will be sorted alphabetically (by surname and name) within that day.
SELECT cName, cSurname, dNewMember FROM tmember ORDER BY dNewMember ASC, cName ASC, cSurname ASC;

SELECT cName, cSurname, dNewMember
FROM tmember
ORDER BY dNewMember DESC, cSurname, cName;
-- not sure either is correct

# 9. Show the title of all books published by the publishing company with ID 32 along with their theme or themes.
SELECT cTitle, cName FROM tbook, ttheme, tbooktheme
WHERE tbook.nPublishingCompanyID = 32
AND tbook.nBookID = tbooktheme.nBookID
AND ttheme.nThemeID = tbooktheme.nThemeID;

# 10. Show the name and surname of every author along with the number of books authored by them,
# but only for authors who have registered books on the database.
SELECT COUNT(cTitle), cName, cSurname
FROM tbook, tauthor, tauthorship
WHERE cTitle IS NOT NULL
AND tauthorship.nAuthorID = tauthor.nAuthorID
AND tauthorship.nBookID = tbook.nBookID
GROUP BY cName, cSurname;

# 11. Show the name and surname of all the authors with published books
# along with the lowest publishing year for their books.
SELECT cName, cSurname, MIN(nPublishingYear)
FROM tauthor, tauthorship, tbook
WHERE tauthor.nAuthorID = tauthorship.nAuthorID
AND tauthorship.nBookID = tbook.nBookID
GROUP BY cName, cSurname;

# 12. For each signature and loan date, show the title of the corresponding books and the name and
# surname of the member who had them loaned.
SELECT tloan.cSignature, tloan.dLoan, tbook.cTitle, tmember.cName, tmember.cSurname
FROM tloan, tbook, tmember, tbookcopy
WHERE tloan.cSignature = tbookcopy.cSignature
AND tloan.cCPR = tmember.cCPR
AND tbookcopy.nBookID = tbook.nBookId;

# 13. Repeat exercises 9 to 12 using the modern JOIN notation.

    # 9.
    SELECT tbook.cTitle, ttheme.cName FROM ((tbook
        INNER JOIN tbooktheme ON tbook.nBookID = tbooktheme.nBookID)
        INNER JOIN ttheme ON ttheme.nThemeID = tbooktheme.nThemeID)
    WHERE tbook.nPublishingCompanyID = 32;

    # 10.
    SELECT COUNT(cTitle), cName, cSurname
    FROM ((tbook
        INNER JOIN tauthorship ON tbook.nBookID = tauthorship.nBookID)
        INNER JOIN tauthor ON tauthor.nAuthorID = tauthorship.nAuthorID)
    WHERE cTitle IS NOT NULL
    GROUP BY cName, cSurname;

    # 11.
    SELECT cName, cSurname, MIN(nPublishingYear) FROM ((tauthor
        INNER JOIN tauthorship ON tauthorship.nAuthorID = tauthor.nAuthorID)
        INNER JOIN tbook ON tbook.nBookID = tauthorship.nBookID)
    GROUP BY cName, cSurname;

    # 12.
    SELECT tloan.cSignature AS book_signature,
        tloan.dLoan AS loan_date,
        tbook.cTitle AS book_title,
        tmember.cName, tmember.cSurname FROM ((tloan
        INNER JOIN tbookcopy ON tloan.cSignature = tbookcopy.cSignature)
        INNER JOIN tmember ON tloan.cCPR = tmember.cCPR)
        INNER JOIN tbook ON tbook.nBookID = tbookcopy.nBookID;

# 14. Show all theme names along with the titles of their associated books.
# All themes must appear (even if there are no books for some particular themes). Sort by theme name.
SELECT cName, cTitle FROM  tbook, ttheme LEFT JOIN tbooktheme t on ttheme.nThemeID = t.nThemeID
WHERE t.nThemeID IS NULL OR t.nThemeID IS NOT NULL AND tbook.nBookID = t.nBookID
ORDER By cName;


# 15. Show the name and surname of all members who joined the library in 2013 along with
# the title of the books they took on loan during that same year.
# All members must be shown, even if they did not take any book on loan during 2013.
# Sort by member surname and name.
SELECT cName, cSurname, if(dLoan LIKE '2013%', tbook.cTitle, '') AS BookRentedIn2013
FROM tmember
         LEFT JOIN tloan on tmember.cCPR = tloan.cCPR
         LEFT JOIN tbookcopy on tloan.cSignature = tbookcopy.cSignature
         LEFT JOIN tbook on tbookcopy.nBookID = tbook.nBookID
WHERE dNewMember LIKE '2013%'
GROUP BY cName, cSurname, if(dLoan LIKE '2013%', tbook.cTitle, '')
ORDER BY cName, cSurname;

# 16. Show the name and surname of all authors along with their nationality or nationalities
# and the titles of their books. Every author must be shown, even though s/he has no registered books.
# Sort by author name and surname.
SELECT tauthor.cName, tauthor.cSurname, tcountry.cName, if(tauthor.nAuthorID <> tauthorship.nBookID, tbook.cTitle, '') AS title
FROM tauthor
         INNER JOIN tnationality ON tauthor.nAuthorID = tnationality.nAuthorID
         INNER JOIN tcountry ON tnationality.nCountryID = tcountry.nCountryID
         INNER JOIN tauthorship ON tauthor.nAuthorID = tauthorship.nAuthorID
         INNER JOIN tbook ON tauthorship.nBookID = tbook.nBookID
ORDER BY  tauthor.cName, cSurname;

# 17. Show the title of those books which have had different editions published in both 1970 and 1989.
SELECT book1.cTitle AS 'Books with releases in 1970 and 1989' FROM tbook book1, tbook book2
WHERE book1.cTitle = book2.cTitle AND book1.nPublishingYear = 1970
AND book2.nPublishingYear = 1989;

# 18.Show the surname and name of all members who joined the library in December 2013
# followed by the surname and name of those authors whose name is “William”.
SELECT Names FROM(
SELECT DISTINCT CONCAT(library.tmember.cSurname, ' ', library.tmember.cName) AS 'Names'
FROM tmember WHERE dNewMember BETWEEN '2013-12-1' AND '2013-12-31'
UNION ALL
SELECT CONCAT(tauthor.cName, ' ', tauthor.cSurname) AS 'Authors named William'
FROM tauthor WHERE cName = 'William') AS SUB;

# 19. Show the name and surname of the first chronological member of the library using subqueries.
SELECT cName, cSurname FROM tmember ORDER BY dNewMember ASC LIMIT 1;

# 20. For each publishing year, show the number of book titles published by publishing companies from countries
# that constitute the nationality for at least three authors. Use subqueries.
SELECT nPublishingYear, COUNT(*) AS 'No. Books Published', cName
FROM tbook, (SELECT cName FROM tcountry
                LEFT JOIN tnationality ON tcountry.nCountryID = tnationality.nCountryID
             GROUP BY cName
             HAVING COUNT(*) >= 3) name
GROUP BY nPublishingYear, cName
ORDER BY nPublishingYear;

# 21. Show the name and country of all publishing companies with the headings "Name" and "Country".
SELECT tcountry.cName AS Country, tpublishingcompany.cName AS Name
FROM tcountry, tpublishingcompany
WHERE tpublishingcompany.nCountryID = tcountry.nCountryID;

# 22. Show the titles of the books published between 1926 and 1978 that were not published
# by the publishing company with ID 32.
SELECT cTitle, nPublishingYear FROM tbook
WHERE nPublishingYear >= 1926 AND nPublishingYear <= 1978
AND nPublishingCompanyID != 32;

# 23. Show the name and surname of the members who joined the library after 2016 and have no address.
SELECT cName, cSurname FROM tmember
WHERE YEAR(dNewMember) > 2016 AND cAddress IS NULL;

# 24. Show the country codes for countries with publishing companies. Exclude repeated values.
SELECT DISTINCT tpublishingcompany.nCountryID FROM tcountry, tpublishingcompany
WHERE tcountry.nCountryID = tpublishingcompany.nCountryID;

SELECT DISTINCT nCountryID
FROM tpublishingcompany
WHERE tpublishingcompany.cName IS NOT NULL;

# 25. Show the titles of books whose title starts by "The Tale" and that are not published by "Lynch Inc".
SELECT cTitle, cName FROM tbook, tpublishingcompany
WHERE cTitle LIKE 'The Tale%' AND tpublishingcompany.cName !='Lynch Inc';

# 26. Show the list of themes for which the publishing company "Lynch Inc" has published books, excluding repeated values.
SELECT DISTINCT ttheme.cName, tpublishingcompany.cName
FROM ttheme, tbooktheme, tbook, tpublishingcompany
WHERE tpublishingcompany.cName = 'Lynch Inc'
AND ttheme.nThemeID = tbooktheme.nThemeID
AND tbooktheme.nBookID = tbook.nBookID
AND tbook.nPublishingCompanyID = tpublishingcompany.nPublishingCompanyID;

# 27. Show the titles of those books which have never been loaned.
SELECT DISTINCT cTitle FROM tbook
WHERE nBookID NOT IN (SELECT nBookID FROM tbookcopy
WHERE cSignature IN(SELECT cSignature FROM tloan WHERE tloan.cSignature IS NOT NULL));

# 28. For each publishing company, show its number of existing books under the heading "No. of Books".
SELECT COUNT(tpublishingcompany.nPublishingCompanyID) AS 'No. of Books', cName AS company FROM tpublishingcompany, tbook
WHERE tpublishingcompany.nPublishingCompanyID = tbook.nPublishingCompanyID
GROUP BY tpublishingcompany.cName;

# 29. Show the number of members who took some book on a loan during 2013.
SELECT COUNT(cName) FROM tmember, tloan
WHERE tloan.cCPR = tmember.cCPR
AND YEAR(dLoan) = 2013;

# 30. For each book that has at least two authors, show its title and number of authors under the heading "No. of Authors".
SELECT tbook.cTitle, COUNT(tauthor.nAuthorID) AS 'No. of Authors'
FROM tbook, tauthor, tauthorship
WHERE tauthorship.nAuthorID = tauthor.nAuthorID
AND tauthorship.nBookID = tbook.nBookID
GROUP BY tbook.cTitle
HAVING `No. of Authors` > 1;