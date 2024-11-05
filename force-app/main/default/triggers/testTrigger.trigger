trigger testTrigger on Account (before insert) {
    system.debug('helloWorld');

}