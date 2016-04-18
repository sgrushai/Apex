// tips one of the fields (checkbox) on an object
trigger UserTrigger on User (before insert) {
    for (User userInLoop : Trigger.new) {
    userInLoop.ForecastEnabled = true;
    }
}