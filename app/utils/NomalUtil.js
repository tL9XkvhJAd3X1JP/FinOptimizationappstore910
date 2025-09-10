import  {
    DeviceEventEmitter
} from 'react-native';

export default class NomalUtil
{
  

    //注册这个监听事件
    static registListener(name,param)
    {
        //注册监听
        //'通知名称'
        DeviceEventEmitter.addListener(name, (param) => {
                                       //收到通知后处理逻辑
                                       //eg 刷新数据
                                       });

                                       
                                       }
                                       
                                       
        //在组件销毁的时候要将其移除
       static removeListener()
        {
            DeviceEventEmitter.remove();
            
        }
    
    //执行某些操作后触发事件通知，param传递参数，参数也可不传递
    static actionListener(name,param){
        //'通知名称'=name
        DeviceEventEmitter.emit(name, param);
        
    }
    
}
//export {
//    remove
//
//};


