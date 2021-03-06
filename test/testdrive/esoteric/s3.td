# Copyright Materialize, Inc. All rights reserved.
#
# Use of this software is governed by the Business Source License
# included in the LICENSE file at the root of this repository.
#
# As of the Change Date specified in that file, in accordance with
# the Business Source License, use of this software will be governed
# by the Apache License, Version 2.0.

$ set bucket=materialize-ci-testdrive-${testdrive.seed}

$ s3-create-bucket bucket=${bucket}

$ s3-put-object bucket=${bucket} key=short/a
a1
a2
a3

$ s3-put-object bucket=${bucket} key=short/b
b1
b2
b3

> CREATE MATERIALIZED SOURCE s3_all
  FROM S3 BUCKET '${bucket}' OBJECTS FROM SCAN
  WITH (
    region = '${testdrive.aws-region}',
    endpoint = '${testdrive.aws-endpoint}',
    access_key_id = '${testdrive.aws-access-key-id}',
    secret_access_key = '${testdrive.aws-secret-access-key}',
    token = '${testdrive.aws-token}'
  )
  FORMAT TEXT;

> SELECT * FROM s3_all ORDER BY mz_record;
a1 1
a2 2
a3 3
b1 4
b2 5
b3 6

> CREATE MATERIALIZED SOURCE s3_glob_a
  FROM S3 BUCKET '${bucket}' OBJECTS FROM SCAN MATCHING '**/a'
  WITH (
    region = '${testdrive.aws-region}',
    endpoint = '${testdrive.aws-endpoint}',
    access_key_id = '${testdrive.aws-access-key-id}',
    secret_access_key = '${testdrive.aws-secret-access-key}',
    token = '${testdrive.aws-token}'
  )
  FORMAT TEXT;

> SELECT * FROM s3_glob_a ORDER BY mz_record;
a1 1
a2 2
a3 3

> CREATE MATERIALIZED SOURCE s3_just_a
  FROM S3 BUCKET '${bucket}' OBJECTS FROM SCAN MATCHING 'short/a'
  WITH (
    region = '${testdrive.aws-region}',
    endpoint = '${testdrive.aws-endpoint}',
    access_key_id = '${testdrive.aws-access-key-id}',
    secret_access_key = '${testdrive.aws-secret-access-key}',
    token = '${testdrive.aws-token}'
  )
  FORMAT TEXT;

> SELECT * FROM s3_just_a ORDER BY mz_record;
a1 1
a2 2
a3 3
