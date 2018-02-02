from alarmSender import AlarmSender
from version import VERSION

_version_ = VERSION

class SendReport(AlarmSender):
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
