select *
from portfolioProject..NashvilleHousing

select SaleDate
from portfolioProject..NashvilleHousing

select CONVERT(date,SaleDate)
from portfolioProject..NashvilleHousing


update portfolioProject..NashvilleHousing
set SaleDate = CONVERT(date,SaleDate)

Alter table  portfolioProject..NashvilleHousing
Add SaleDateConverted date;

update  portfolioProject..NashvilleHousing
set SaleDateConverted = CONVERT(date,SaleDate)


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress , ISNULL(a.PropertyAddress,b.PropertyAddress)
from portfolioProject..NashvilleHousing a
join portfolioProject..NashvilleHousing b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ]<> b.[UniqueID ]
  where a.PropertyAddress is null


  update a
  set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
  from portfolioProject..NashvilleHousing a
join portfolioProject..NashvilleHousing b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ]<> b.[UniqueID ]
 where a.PropertyAddress is null

-- Breaking Down Address INTO Individual coulmns

select  SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN (PropertyAddress))
from portfolioProject..NashvilleHousing

Alter table  portfolioProject..NashvilleHousing
Add ProppertySplitAddress nvarchar(255);

update  portfolioProject..NashvilleHousing
set ProppertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)



Alter table  portfolioProject..NashvilleHousing
Add ProppertySplitCity nvarchar(255);

update  portfolioProject..NashvilleHousing
set ProppertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN (PropertyAddress))

select OwnerAddress, PARSENAME(replace (OwnerAddress,',','.'),3)
,PARSENAME(replace (OwnerAddress,',','.'),2)
,PARSENAME(replace (OwnerAddress,',','.'),1)
from portfolioProject..NashvilleHousing

Alter table  portfolioProject..NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

update  portfolioProject..NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace (OwnerAddress,',','.'),3)


Alter table  portfolioProject..NashvilleHousing
Add OwnerSplitCity nvarchar(255);

update  portfolioProject..NashvilleHousing
set OwnerSplitCity = PARSENAME(replace (OwnerAddress,',','.'),2)


Alter table  portfolioProject..NashvilleHousing
Add OwnerSplitState nvarchar(255);

update  portfolioProject..NashvilleHousing
set OwnerSplitState = PARSENAME(replace (OwnerAddress,',','.'),1)


--Change Y and N to YES and NO in 'Sold As Vacant'

select Soldasvacant,
case 
when soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'n' then 'NO'
else soldasvacant
end
from portfolioProject..NashvilleHousing

update portfolioProject..NashvilleHousing
set Soldasvacant = case 
when soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'n' then 'NO'
else soldasvacant
end

--Remove Duplicates

with RowNumCTE as(
select *,
ROW_NUMBER () over (
partition by ParcelID,
            PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			order by 
			UniqueID
			) row_num

from portfolioProject..NashVilleHousing
--order by ParcelID
)
delete
from RowNumCTE
where row_num > 1
--order by PropertyAddress


--Delete Unused columns


 

Alter table portfolioProject..NashvilleHousing 
drop column SaleDate , PropertyAddress, OwnerAddress , TaxDistrict
