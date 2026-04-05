---
name: pytest
description: Pytest testing patterns for Python. Trigger When writing or refactoring pytest tests (fixtures, mocking, parametrize, markers).
---

## Basic Test Structure

```python
import pytest

class TestUserService:
    def test_create_user_success(self):
        user = create_user(name="John", email="john@test.com")
        assert user.name == "John"
        assert user.email == "john@test.com"

    def test_create_user_invalid_email_fails(self):
        with pytest.raises(ValueError, match="Invalid email"):
            create_user(name="John", email="invalid")
```

## Fixtures

```python
import pytest

@pytest.fixture
def user():
    """Create a test user."""
    return User(name="Test User", email="test@example.com")

@pytest.fixture
def authenticated_client(client, user):
    """Client with authenticated user."""
    client.force_login(user)
    return client

# Fixture with teardown
@pytest.fixture
def temp_file():
    path = Path("/tmp/test_file.txt")
    path.write_text("test content")
    yield path  # Test runs here
    path.unlink()  # Cleanup after test

# Fixture scopes
@pytest.fixture(scope="module")  # Once per module
@pytest.fixture(scope="class")   # Once per class
@pytest.fixture(scope="session") # Once per test session
```

## conftest.py

```python
# tests/conftest.py - Shared fixtures
import pytest

@pytest.fixture
def db_session():
    session = create_session()
    yield session
    session.rollback()

@pytest.fixture
def api_client():
    return TestClient(app)
```

## Mocking

Refer to [Mocker Usage](https://pytest-mock.readthedocs.io/en/latest/usage.html)

```python
from pytest_mock import MockerFixture
from services.payment import process_payment, get_user_info, PaymentError

class TestPaymentService:
    def test_process_payment_success(self, mocker: MockerFixture):
        # mocker.patch returns a MagicMock automatically
        mock_stripe = mocker.patch("services.payment.stripe_client")
        mock_stripe.charge.return_value = {"id": "ch_123", "status": "succeeded"}

        result = process_payment(amount=100)

        assert result["status"] == "succeeded"
        mock_stripe.charge.assert_called_once_with(amount=100)

    def test_process_payment_failure(self, mocker: MockerFixture):
        mock_stripe = mocker.patch("services.payment.stripe_client")
        mock_stripe.charge.side_effect = PaymentError("Card declined")

        with pytest.raises(PaymentError):
            process_payment(amount=100)

# For complex objects, use mocker.Mock() or mocker.MagicMock()
def test_with_mock_object(mocker: MockerFixture):
    mock_user = mocker.MagicMock() 
    mock_user.id = "user-123"
    mock_user.name = "Test User"
    mock_user.is_active = True

    result = get_user_info(mock_user)
    assert result["name"] == "Test User"
```

## Parametrize

```python
@pytest.mark.parametrize(
    argnames=["input", "expected"],
    argvalues=[
    ("hello", "HELLO"),
    ("world", "WORLD"),
    ("pytest", "PYTEST"),
    ids=["test_hello", "test_world", "test_pytest"]
])
def test_uppercase(input, expected):
    assert input.upper() == expected

@pytest.mark.parametrize(
    argnames=["email", "is_valid"],
    argvalues=[
    ("user@example.com", True),
    ("invalid-email", False),
    ("", False),
    ("user@.com", False),
    ids=["test_valid_email", "test_invalid_email", "test_empty_email", "test_invalid_email_domain"]
])
def test_email_validation(email, is_valid):
    assert validate_email(email) == is_valid
```

Se more on [Parametrizing tests](https://docs.pytest.org/en/stable/example/parametrize.html)

## Markers

```python
# pytest.ini or pyproject.toml
[tool.pytest.ini_options]
markers = [
    "slow: marks tests as slow",
    "integration: marks integration tests",
]

# Usage
@pytest.mark.slow
def test_large_data_processing():
    ...

@pytest.mark.integration
def test_database_connection():
    ...

@pytest.mark.skip(reason="Not implemented yet")
def test_future_feature():
    ...

@pytest.mark.skipif(sys.platform == "win32", reason="Unix only")
def test_unix_specific():
    ...

# Run specific markers
# pytest -m "not slow"
# pytest -m "integration"
```

Se more on [Working with custom markers](https://docs.pytest.org/en/stable/example/markers.html)

## Async Tests

```python
import pytest

@pytest.mark.asyncio
async def test_async_function():
    result = await async_fetch_data()
    assert result is not None
```

## Commands

```bash
pytest                          # Run all tests
pytest -v                       # Verbose output
pytest -x                       # Stop on first failure
pytest -k "test_user"           # Filter by name
pytest -m "not slow"            # Filter by marker
pytest --cov=src                # With coverage
pytest -n auto                  # Parallel (pytest-xdist)
pytest --tb=short               # Short traceback
```

## References

For general test see [pytest documentation](https://docs.pytest.org/en/stable/)

To understand the test basics see [Anatomy of a test](https://docs.pytest.org/en/stable/explanation/anatomy.html)

Review [Typing in pytest](https://docs.pytest.org/en/stable/explanation/types.html) to enhances clarity, improves debugging and maintenance, and ensures type safety.

For how to setup and teardown test state see [How to implement xunit-style set-up](https://docs.pytest.org/en/stable/how-to/xunit_setup.html)

For AWS testing with AWS patterns (moto, MagicMock), see: [aws-testing.md](references/aws-testing.md)
