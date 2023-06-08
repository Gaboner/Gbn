Select *
FROM Housing


--Converting date to standard format--
select Saledate, CONVERT(Date,Saledate)
FROM Housing

UPDATE Housing
SET Saledate = CONVERT(Date,Saledate)

--Did not work, do not know why, trying alternative--

ALTER TABLE Housing   ---Created a new date column---
Add SaleDateConverted Date

Update Housing

SET SaleDateConverted = CONVERT(Date,Saledate)
-------------------------------------------------------------------------------




--Populatin Null values in PropertyAddress--

Select L1.ParcelID, L1.PropertyAddress, L2.ParcelID, L2.PropertyAddress, ISNULL(L1.PropertyAddress,L2.PropertyAddress)  --ISNULL function returns all null values from L1.Propertyaddress Column
From Housing L1
Join Housing L2   --Self join table
	on L1.ParcelID = L2.ParcelID  -- ParcelID's that share the same value can use same PropertyAddress
	And L1.[UniqueID ] <> L2.[UniqueID ] -- We can distinguish ParcelID by UniqueID
Where L1.PropertyAddress is null -- Shows all Null values


Update L1
	SET PropertyAddress = ISNULL(L1.PropertyAddress,L2.PropertyAddress) --populate L1 Column
	From Housing L1
	Join Housing L2   
	on L1.ParcelID = L2.ParcelID  
	And L1.[UniqueID ] <> L2.[UniqueID ] 


Select PropertyAddress
From Housing
Where PropertyAddress is null --we can check if there are any NULL values left

---------------------------------------------------------------------------------------------------------


--Separating City from Property Address--


----Select 
--Substring (PropertyAddress, 1, 18) AS Address,  --Extracting characters from string --
--Substring (PropertyAddress, 20, 33) AS City  --Extracting characters from string--
--From Housing

--

---One different way of doing it --
Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,       
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS City

FROM Housing


ALTER TABLE Housing   
Add Address Nvarchar(255)

Update Housing

SET Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 


ALTER TABLE Housing   
Add City Nvarchar(255)

Update Housing
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


--Created new columns with address and city

--------------------------------------------------------------------------------------------------




----Separating values again, easier way--- 
Select 
PARSENAME(REPLACE (OwnerAddress, ',', '.'), 3),  --Using PARSENAME function to delimit by a specific value--
PARSENAME(REPLACE (OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE (OwnerAddress, ',', '.'), 1)
From Housing



ALTER TABLE Housing   
Add OwnerAddressNew Nvarchar(255)

Update Housing
SET OwnerAddressNew = PARSENAME(REPLACE (OwnerAddress, ',', '.'), 3)	


ALTER TABLE Housing   
Add OwnerCity Nvarchar(255)

Update Housing
SET OwnerCity = PARSENAME(REPLACE (OwnerAddress, ',', '.'), 2)


ALTER TABLE Housing   
Add OwnerState Nvarchar(255)

Update Housing
SET OwnerState = PARSENAME(REPLACE (OwnerAddress, ',', '.'), 1)



---------------------------------------------------------------------------------------------------


--Remove duplicates--


With RownumCTE AS(                   --Create CTE, acts like temptable--

select *,
ROW_NUMBER() OVER(
	Partition by PropertyAddress,
				SaleDate,
				SalePrice,            --count number of rows that have the same values in the specified columns --
				LegalReference,
				ParcelID
			Order by UniqueID) Row_num
From Housing
)

--DELETE--  
Select *
FROM RownumCTE
where Row_num > 1           --select duplicate rows and delete--
order by [UniqueID ]



-------------------------------------------------------------------------------------------------

Select * from Housing






