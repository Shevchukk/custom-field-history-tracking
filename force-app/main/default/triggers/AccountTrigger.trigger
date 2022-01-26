trigger AccountTrigger on Account (after update) {
    TrackActivity.trackFieldsChanges(Trigger.old, Trigger.new);
}