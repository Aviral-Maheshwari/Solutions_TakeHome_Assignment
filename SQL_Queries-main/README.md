# Public Database SQL Analysis

Based on: [Rfam Database Documentation](https://docs.rfam.org/en/latest/database.html)

## a) Tiger Subspecies
```sql
SELECT COUNT(DISTINCT species) as tiger_types
FROM taxonomy 
WHERE species LIKE '%tigris%' OR species LIKE '%Panthera tigris%';

SELECT ncbi_id, species, common_name
FROM taxonomy 
WHERE species = 'Panthera tigris sumatrae';

```
## b) All the columns that can be used to connect the tables in the given database.
```sql
SELECT 1 AS id, 'family.rfam_acc → clan_membership.rfam_acc' AS relationship
UNION ALL
SELECT 2, 'clan.clan_acc → clan_membership.clan_acc'
UNION ALL
SELECT 3, 'family.rfam_acc → full_region.rfam_acc'
UNION ALL
SELECT 4, 'rfamseq.rfamseq_acc → full_region.rfamseq_acc'
UNION ALL
SELECT 5, 'rfamseq.ncbi_id → taxonomy.ncbi_id'
ORDER BY id;
```
## c) Type of rice has the longest DNA sequence
```sql
SELECT t.species, t.common_name, r.length
FROM rfamseq r
JOIN taxonomy t ON r.ncbi_id = t.ncbi_id
WHERE t.species LIKE '%oryza%' OR t.common_name LIKE '%rice%'
ORDER BY r.length DESC
LIMIT 1;
```

## d) List of the family names and their longest DNA sequence lengths
```sql
SELECT f.rfam_acc, f.rfam_id, MAX(rs.length) AS max_sequence_length
FROM family f
JOIN full_region fr ON f.rfam_acc = fr.rfam_acc
JOIN rfamseq rs ON fr.rfamseq_acc = rs.rfamseq_acc
GROUP BY f.rfam_acc, f.rfam_id
HAVING max_sequence_length > 1000000
ORDER BY max_sequence_length DESC
LIMIT 15 OFFSET 120;
```
