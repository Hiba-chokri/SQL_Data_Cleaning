--cleaning data
Select * From PortfolioPro2.dbo.[Nashville Housing]
--change date Format
SELECT SaleDate, CONVERT(Date,SaleDate)
From PortfolioPro2.dbo.[Nashville Housing]
UPDATE PortfolioPro2.dbo.[Nashville Housing]
SET SaleDate =  CONVERT(Date, SaleDate)

 ALTER TABLE PortfolioPro2.dbo.[Nashville Housing]
 ADD SaleDateConverted Date;

 UPDATE PortfolioPro2.dbo.[Nashville Housing]
 SET SaleDateConverted = CONVERT(Date, SaleDate)

 SELECT SaleDateConverted FROM PortfolioPro2.dbo.[Nashville Housing]
 --changing where Prop adress is null
 Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
 from PortfolioPro2.dbo.[Nashville Housing] a
 join PortfolioPro2.dbo.[Nashville Housing] b
 on a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null
 UPDATE a
 SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
 from PortfolioPro2.dbo.[Nashville Housing] a
 join PortfolioPro2.dbo.[Nashville Housing] b
 on a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null
 --separating adress and city in PropAdress
 SELECT 
 SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Adress ,
 SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as City
 FROM PortfolioPro2..[Nashville Housing]
 ALTER TABLE [Nashville Housing]
 ADD PropertySplitAdress Nvarchar(255);

 UPDATE [Nashville Housing]
 SET PropertySplitAdress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

 ALTER TABLE [Nashville Housing]
 ADD PropertySplitCity Nvarchar(255);

 UPDATE [Nashville Housing]
 SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
 
 SELECT PropertySplitAdress,PropertySplitCity
 FROM PortfolioPro2.dbo.[Nashville Housing]

 --Spliting OwnerAdress
 SELECT 
 PARSENAME(REPLACE(OwnerAddress,',','.'),3)
 ,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
 ,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
 FROM PortfolioPro2.dbo.[Nashville Housing]
 --adding the columns
 ALTER TABLE [Nashville Housing]
 ADD OwnerSplitAdress Nvarchar(255);
 UPDATE [Nashville Housing]
 SET OwnerSplitAdress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

 ALTER TABLE [Nashville Housing]
 ADD OwnerSpiltCity Nvarchar(255);

 UPDATE [Nashville Housing]
 SET OwnerSpiltCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

 ALTER TABLE [Nashville Housing]
 ADD OwnerSplitState Nvarchar(255);
  UPDATE [Nashville Housing]
 SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)
 
 SELECT OwnerSplitAdress, OwnerSpiltCity,OwnerSplitState
 FROM PortfolioPro2.dbo.[Nashville Housing]
 
 --Replacing N with No and Y with Yes 
 SELECT DISTINCT (SoldAsVacant) ,COUNT(SoldAsVacant)
 FROM PortfolioPro2.dbo.[Nashville Housing]
 GROUP BY SoldAsVacant
 Order By 2

SELECT SoldAsVacant,
 CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
      WHEN SoldAsVacant = 'N' THEN 'NO'
	  ELSE SoldAsVacant 
      END
FROM PortfolioPro2.dbo.[Nashville Housing]
UPDATE [Nashville Housing]
SET SoldAsVacant =  CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
      WHEN SoldAsVacant = 'N' THEN 'NO'
	  ELSE SoldAsVacant 
      END
--Removing Duplicates
WITH RowNumCte AS(
SELECT *,
        ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
			   PropertyAddress,
			   SalePrice,
			   SaleDate,
			   LegalReference
			   ORDER BY UniqueID 
			   ) RowNum
FROM PortfolioPro2.dbo.[Nashville Housing]
--ORDER BY ParcelID
)
SELECT * FROM RowNumCte
DELETE 
from RowNumCte
where RowNum > 1

--Deleting columns we dont need
ALTER TABLE PortfolioPro2.dbo.[Nashville Housing]
DROP COLUMN OwnerAddress,SaleDate,PropertyAddress

SELECT * FRom PortfolioPro2.dbo.[Nashville Housing]
