/*

Cleaning Data in SQL Queries

*/


Select *
From DataCleaning.dbo.NashvilleHousing 

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format





Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;


Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

Select   SaleDateConverted, CONVERT(Date,SaleDate)
From DataCleaning.dbo.NashvilleHousing
 
 
 

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From DataCleaning.dbo.NashvilleHousing
Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From DataCleaning.dbo.NashvilleHousing a
JOIN DataCleaning.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From DataCleaning.dbo.NashvilleHousing a
JOIN DataCleaning.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From DataCleaning.dbo.NashvilleHousing
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address ,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From DataCleaning.dbo.NashvilleHousing

 Select
  RIGHT(PropertyAddress, 2) AS State
From DataCleaning.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertyCity Nvarchar(255);

Update NashvilleHousing
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From DataCleaning.dbo.NashvilleHousing 


use DataCleaning


Select OwnerAddress
From DataCleaning.dbo.NashvilleHousing 


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) 
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From DataCleaning.dbo.NashvilleHousing

use DataCleaning

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From DataCleaning.dbo.NashvilleHousing 

UPDATE DataCleaning.dbo.NashvilleHousing
SET OwnerSplitCity = 'Nashville'
WHERE OwnerSplitCity IS NULL OR OwnerSplitCity = '';

UPDATE DataCleaning.dbo.NashvilleHousing
SET OwnerSplitState = 'TN'
WHERE OwnerSplitState IS NULL OR OwnerSplitState = '';





--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From DataCleaning.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From DataCleaning.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From DataCleaning.dbo.NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


--Delete From RowNumCTE
--Where row_num > 1

Select *
From DataCleaning.dbo.NashvilleHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From DataCleaning.dbo.NashvilleHousing order by [UniqueID ]


ALTER TABLE DataCleaning.dbo.NashvilleHousing
DROP COLUMN  SaleDate,OwnerAddress, TaxDistrict, PropertyAddress




-----------------------------------------------------------------------------------------------
---This script performs comprehensive data cleaning on the NashvilleHousing dataset to enhance data consistency, accuracy, and usability.
---It includes

--------------------Standardize Date Format-----------------------------------------------------------------------------------------------
--Converts SaleDate to a uniform DATE format and creates SaleDateConverted for consistency.

--------------------Populate Property Address data-----------------------------------------------------------------------------------------
--Fills in NULL values by referencing other records with the same ParcelID.

-------------------Breaking out Address into Individual Columns (Address, City, State)-----------------------------------------------------
-- Extracts and stores PropertyAddress, OwnerAddress, city, and state into separate columns.

-------------------Standardizing Owner Location Data-----------------------------------------------------------------------------
--Ensures all missing OwnerCity values are set to 'Nashville' and OwnerState to 'TN'.

---------------------Change Y and N to Yes and No in "Sold as Vacant" field------------------------------------------------------
--Converts SoldAsVacant values from 'Y'/'N' to 'Yes'/'No' for readability.

----------------------Remove Duplicates------------------------------------------------------------------------------------------
--- Identifies and eliminates duplicate entries based on key property attributes.

-----------------Delete Unused Columns-------------------------------------------------------------------------------------------
--Drops redundant fields (SaleDate, OwnerAddress, TaxDistrict, PropertyAddress) to streamline the dataset.--
















