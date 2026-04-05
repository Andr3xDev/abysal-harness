Below are key resources and insights gained throughout the testing process.

**Python Testing**

- https://docs.python-guide.org/writing/tests/

**Where to Patch**

- https://docs.python.org/3/library/unittest.mock.html#where-to-patch
- https://stackoverflow.com/questions/893333/multiple-variables-in-a-with-statement
- ​https://docs.python.org/3/reference/compound_stmts.html#the-with-statement

## General Recommendations

Follow these guidelines to maximize coverage across test scenarios:

1. Zero Findings Scenario:
Develop tests where no resources exist.

2. Positive and Negative Outcomes:
Create tests that generate both a passing (`PASS`) and a failing (`FAIL`) result.

3. Multi-Resource Evaluations:
Design tests with multiple resources to verify check behavior and ensure the correct number of findings.

Note: Refer to the [pytest documentation](https://docs.pytest.org/en/latest/contents.html) for more details.

## AWS Testing Approaches

For AWS provider, different testing approaches apply based on API coverage based on several criteria.

- AWS API Calls Covered by [Moto](https://github.com/getmoto/moto):
  - Service Tests: `@mock_aws`
  - Checks Tests: `@mock_aws`

- AWS API Calls Not Covered by Moto:
  - Service Tests: `mock_make_api_call`
  - Checks Tests: [MagicMock](https://docs.python.org/3/library/unittest.mock.html#unittest.mock.MagicMock)

- AWS API Calls Partially Covered by Moto:
  - Service Tests: `@mock_aws` and `mock_make_api_call`
  - Checks Tests: `@mock_aws` and `mock_make_api_call`

### AWS Check Testing Scenarios

The following section provides examples for each testing scenario. The primary distinction between these scenarios depends on whether the [Moto](https://github.com/getmoto/moto) library covers the AWS API calls made by the service. You can review the supported API calls in [Moto Implementation Coverage](https://github.com/getmoto/moto/blob/master/IMPLEMENTATION_COVERAGE.md).

### AWS Check Testing Approach

For AWS test examples, we reference tests for the `iam_password_policy_uppercase` check.

This section is categorized based on [Moto](https://github.com/getmoto/moto) API coverage.

### Recommended Usage

1. Ensure that your tests executions have dummy environment variables set up:

    ```bash
    export AWS_ACCESS_KEY_ID='testing'
    export AWS_SECRET_ACCESS_KEY='testing'
    export AWS_SECURITY_TOKEN='testing'
    export AWS_SESSION_TOKEN='testing'
    export AWS_DEFAULT_REGION='us-east-1'
    ```

2. Do not embed credentials directly in the code. This is always considered bad practice, regardless of whether you use Moto.

### Fixtures Example Usage

Leverage pytest fixtures to help set up mocks and other AWS resources that would be needed.

Here is an example:

```python
@pytest.fixture(scope="function")
def s3():
    """
    Return a mocked S3 client
    """
    with mock_aws():
        yield boto3.client("s3", region_name="us-east-1")

@pytest.fixture
def create_bucket1(s3):
    s3.create_bucket(Bucket="bb1")

@pytest.fixture
def create_bucket2(s3):
    s3.create_bucket(Bucket="bb2")

def test_s3_bucket_creation(s3):
    s3.create_bucket(Bucket="somebucket")

    result = s3.list_buckets()
    assert len(result["Buckets"]) == 1

def test_s3_bucket_creation_through_fixtures(create_bucket1, create_bucket2):
    result = boto3.client("s3").list_buckets()
    assert len(result["Buckets"]) == 2

@mock_aws
def test_generic_aws_fixture():
    s3_client = boto3.client("s3")
    s3_client.create_bucket(Bucket="somebucket")
```

#### API Calls Covered by Moto

When the [Moto](https://github.com/getmoto/moto) library supports the API calls required for testing, use the `@mock_aws` decorator. This ensures that all AWS API calls within the decorated function are properly mocked while maintaining state within the test.

```python
import boto3
from moto import mock_aws
from mymodule import MyModel

@mock_aws
def test_my_model_save():
    conn = boto3.resource("s3", region_name="us-east-1")
    # We need to create the bucket since this is all in Moto's 'virtual' AWS account
    conn.create_bucket(Bucket="mybucket")

    model_instance = MyModel("steve", "is awesome")
    model_instance.save()

    body = conn.Object("mybucket", "steve").get()["Body"].read().decode("utf-8")

    assert body == "is awesome"
```

It is also possible to use decorators on the class-level.

The decorator is effective for every test-method inside your class. State is not shared across test-methods.

```python
@mock_aws
class TestMockClassLevel:
    @classmethod
    def setup_class(cls):
        s3 = boto3.client("s3", region_name="us-east-1")
        s3.create_bucket(Bucket="mybucket")

    def test_creating_a_bucket(self):
        # 'mybucket', created in setUp, is accessible in this test
        # Other clients can be created at will

        s3 = boto3.client("s3", region_name="us-east-1")
        s3.create_bucket(Bucket="bucket_inside")

    def test_accessing_a_bucket(self):
        # The state has been reset before this method has started
        # 'mybucket' is recreated as part of the setUp-method
        # 'bucket_inside' however, created inside the other test, no longer exists
        pass
```

#### Handling API Calls Not Covered by Moto

If the IAM service required for testing is not supported by the Moto library, use [MagicMock](https://docs.python.org/3/library/unittest.mock.html#unittest.mock.MagicMock) to inject objects into the service client.

Warning: As stated above, direct service instantiation must be avoided to prevent actual AWS API calls.

#### Additional Resources on Mocking Imports

For a deeper understanding of mocking imports in Python, refer to the following article: [How to mock an import](https://stackoverflow.com/questions/8658043/how-to-mock-an-import)
