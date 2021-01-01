## sqlite3 -> mysql
1. sqlite3 db.sqlite3
    - `.output <path>`
    - `.dump`
    - `.exit`
2. sqlite3-to-mysql <path> > mysql.dump.sql
3. gsutil cp into bucket
4. Grant cloud-sql SA bucket perms
    - gcloud sql instances describe <instance> | grep serviceAccountEmailAddress
    - gsutiliam ch serviceAccount:<sa-email>:legacyBucketWriter,objectViewer gs://uri
5. cloud sql import sql <instance> gs://uri --database=<dbname>
