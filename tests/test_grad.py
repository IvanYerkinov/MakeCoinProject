import brownie
import pytest


@pytest.fixture(scope="module")
def grad(Gratitude, accounts):
    return Gratitude.deploy({'from': accounts[0]})


@pytest.fixture(autouse=True)
def shared_setup(fn_isolation):
    pass


def test_grad_creation(accounts, grad):
    grad.makeGrad("Test")
    id = grad.getLatestId()

    assert id == 0


def test_owner(accounts, grad):
    grad.makeGrad("Test")
    id = grad.getLatestId()

    assert grad.getOwnerOfGrad(id) == accounts[0]


def test_transfer_grad(accounts, grad):
    grad.makeGrad("Test")
    id = grad.getLatestId()
    grad.transferGrad(accounts[1], id)

    assert grad.getOwnerOfGrad(id) == accounts[1]


def test_resend_grad(accounts, grad, Gratitude):
    grad.makeGrad("Test")
    id = grad.getLatestId()
    grad.transferGrad(accounts[1], id)

    grad.resendGrad(id, accounts[1], accounts[2], "Test2")

    assert grad.getOwnerOfGrad(id) == accounts[2]
