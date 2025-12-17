# Database Indexing: High-Level Overview

This document provides a high-level overview of database indexing, including what an index is, the problems it solves, common types of indexes, and when to use them. For a deeper dive, visit the Hello Interview website.

---

## What Problem Does Indexing Solve?

- Data in a database is arranged in pages (usually 8KB each).
- Without indexing, finding a specific item requires scanning each page sequentially, which is slow for large tables.
- Example: With 100 million users and 100 rows per page, there are 1 million pages. Each SSD-to-RAM round trip is ~100 microseconds, so a worst-case scan could take 100 seconds (realistically 3-5 seconds with optimizations).
- This is much longer than users are willing to wait for a query.

## How Do Indexes Help?

- Indexes are data structures stored on disk that act as a map, telling the database where items exist.
- When a query comes in, the index is loaded into memory, and it tells the database which page to load, avoiding a full scan.

---

## Types of Indexes

### 1. B-Tree Indexes - exact lookups and range queries.
- Most popular type.
- Tree structure where each node is a sorted list of values with pointers to child nodes or data pages.
- Efficient for exact lookups and range queries.
- Example: To find users with age 51, the index is traversed to the correct page.
- For range queries (e.g., age > 51), multiple pages are loaded as needed.
<img width="958" height="446" alt="image" src="https://github.com/user-attachments/assets/eb2e0453-d1e5-43ef-9da6-d31d0588eaf0" />


### 2. Hash Indexes - Maps key to hash
- Simple hash map from key to page location.
- Great for exact matches (O(1) lookup).
- Rarely used in production databases because B-trees are nearly as fast for exact matches and also support range queries and sorting.
- Common in in-memory stores (e.g., **Redis**).
<img width="820" height="455" alt="image" src="https://github.com/user-attachments/assets/786b8cb7-b7e2-4e52-a08b-a3aa94d4bfb6" />

### 3. Geospatial Indexes
- Used for two-dimensional data (latitude/longitude).
- B-trees are not efficient for these queries.
- Three main types:
  - **Geohashing**: Recursively splits the world into cells, **encodes locations as strings, and builds a B-tree on the hashes**. Nearby locations share **prefixes**.
  - **Quad Trees**: Recursively splits the world into four grids, **creating a tree**. Only **splits further** where density is high.
  - **R-Trees**: Like quad trees but **more dynamic**, clustering nearby locations and allowing **overlap**. Used in PostGIS for PostgreSQL.

   <img width="890" height="483" alt="image" src="https://github.com/user-attachments/assets/6799a1d0-dc87-47a4-ab17-1cf8ff331d9a" />
   <img width="768" height="527" alt="image" src="https://github.com/user-attachments/assets/7295bceb-cfd0-460f-aa8c-ba58a9945799" />
   <img width="893" height="487" alt="image" src="https://github.com/user-attachments/assets/17e9c34f-3a34-4978-9c34-92f76c58c46a" />


### 4. Inverted Indexes
- Used for full-text search (e.g., finding all businesses with 'pizza' in the name). B-Tree can not solve it as B-Tree is efficent in case of sorted indexes 
- So it works otherway knowing that user will search by words , So let's Maps each word/token to the documents/pages it appears in.
- Used in *Elasticsearch*, *PostgreSQL full-text search*, Lucene, etc.

---

## When Not to Use B-Trees
- Geospatial data (use geohashing, quad trees, or R-trees).
- Full-text search (use inverted indexes).
- In-memory exact match (hash index, but B-tree is often sufficient).

---

<img width="1001" height="817" alt="image" src="https://github.com/user-attachments/assets/0ffa849d-89e5-4b25-a4d4-ee47f0721e6e" />

## Index Selection Flowchart
- Do you need efficient data access?
  - No: Full table scan is fine.
  - Yes: Do you have a lot of rows?
    - No: Full table scan is still fine.
    - Yes: What type of data?
      - Text: Use inverted index.
      - Location: Use geospatial index.
      - Exact match in memory: Consider hash index.
      - Everything else: Use B-tree.

---

## Key Takeaways
- Understand where queries are inefficient and which columns to index.
- Know the special indexes for specific data types.
- In interviews, focus on recognizing inefficiencies and choosing the right index, not on implementation details.

---

*For more details, visit the Hello Interview website or see the deep dive on database indexing.*
