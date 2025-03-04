-- Write a query to find the total number of invoices in the invoices table.
-- Expected Columns: total_invoices
-- Order By: N/A
SELECT COUNT(*) AS total_invoices
FROM invoices;

-- Write a query to determine the total amount of all invoices (invoice_total).
-- Expected Columns: total_invoice_amount
-- Order By: N/A
SELECT SUM(invoice_total) AS total_invoice_amount
FROM invoices;

-- Find the average invoice total for all invoices.
-- Expected Columns: average_invoice_total
-- Order By: N/A
SELECT AVG(invoice_total) AS average_invoice_total
FROM invoices;

-- Find the highest and lowest invoice totals from the invoices table.
-- Expected Columns: highest_invoice_total, lowest_invoice_total
-- Order By: N/A
SELECT 
    MAX(invoice_total) AS highest_invoice_total,
    MIN(invoice_total) AS lowest_invoice_total
FROM invoices;

-- Write a query to find the total amount paid (payment_total) by each vendor. Display the vendor_id and total amount paid.
-- Expected Columns: vendor_id, total_amount_paid
-- Order By: total_amount_paid DESC
SELECT 
    vendor_id, 
    SUM(payment_total) AS total_amount_paid
FROM payments
GROUP BY vendor_id
ORDER BY total_amount_paid DESC;

-- List the total number of invoices and the total invoice amount grouped by vendor_id. Display the vendor_id, the number of invoices, and the total invoice amount.
-- Expected Columns: vendor_id, invoice_count, total_invoice_amount
-- Order By: total_invoice_amount DESC
SELECT 
    vendor_id, 
    COUNT(*) AS invoice_count, 
    SUM(invoice_total) AS total_invoice_amount
FROM invoices
GROUP BY vendor_id
ORDER BY total_invoice_amount DESC;

-- Find the total line_item_amount for each general ledger account. Display account_number along with the total line_item_amount.
-- Expected Columns: account_number, total_line_item_amount
-- Order By: total_line_item_amount DESC
SELECT 
    account_number, 
    SUM(line_item_amount) AS total_line_item_amount
FROM general_ledger
GROUP BY account_number
ORDER BY total_line_item_amount DESC;

-- Write a query using the ROLLUP extension in GROUP BY to display the total invoice amount for each vendor, including a grand total.
-- Expected Columns: vendor_id, total_invoice_amount
-- Order By: vendor_id ASC
SELECT 
    vendor_id, 
    SUM(invoice_total) AS total_invoice_amount
FROM invoices
GROUP BY vendor_id
WITH ROLLUP
ORDER BY vendor_id ASC;
