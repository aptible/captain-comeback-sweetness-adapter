import logging
from captain_comeback_sweetness_adapter import restart


logging.basicConfig(level=logging.DEBUG)


class MockCgroup(object):
    def name(self):
        return "foo-container"


restart(MockCgroup())
