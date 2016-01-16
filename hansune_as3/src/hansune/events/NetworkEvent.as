package hansune.events
{
    import flash.events.Event;
    
    public class NetworkEvent extends Event
    {
        static public const CHANGE:String = "change";
        
        private var _online:Boolean;
        public function get online():Boolean {
            return _online;
        }
        public function NetworkEvent(type:String, online:Boolean, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            this._online = online;
            super(type, bubbles, cancelable);
        }
    }
}