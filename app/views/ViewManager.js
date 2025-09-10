/**
 * @format
 */
import { AppRegistry } from "react-native";
import PersionCenter from "./PersionCenter";
import CarArchives from "./CarArchives";
import LoginView from "./LoginView";
import SelectCarList from "./SelectCarList";
import GpsSet from "./GpsSet";
import WarnDeal from "./WarnDeal";
import Main from "./Main";
import TestListView from "./TestListView";
import WarningList from "./WarningList";
import WarningList2 from "./WarningList2";
import Login from "./Login";
import UserRequest from "../bussiness/UserRequest";
//android ios 差异化导入
import DifferentMethod from "../utils/DifferentMethod";
//import PopView1 from "../components/PopView1"
import TrackPlay from "./TrackPlay";
import WarnLocation from "./WarnLocation";
import UnusualTogether from "./UnusualTogether";
import LoadingReact from './LoadingReact'

//接下来直接用 StorageUtil.save/remove等等的方法就行啦，并不需要再次import 了！
import StorageUtil from "../utils/StorageUtil";
import SingleData from "../utils/SingleData";
global.StorageUtil = StorageUtil;
global.UserRequest = UserRequest;
global.navigation = {
  PersionCenter: "PersionCenter",
  CarArchives: "CarArchives",
  SelectCarList: "SelectCarList",
  GpsSet: "GpsSet",
  WarnDeal: "WarnDeal",
  Main: "Main",
  TestListView: "TestListView",
  WarningList: "WarningList",
  Login: "Login",
  TrackPlay: "TrackPlay",
  WarnLocation: "WarnLocation",
  UnusualTogether: "UnusualTogether",
  WarningList2: "WarningList2",
  LoadingReact:"LoadingReact"
};

AppRegistry.registerComponent("PersionCenter", () => PersionCenter);
AppRegistry.registerComponent("CarArchives", () => CarArchives);
AppRegistry.registerComponent("SelectCarList", () => SelectCarList);
AppRegistry.registerComponent("GpsSet", () => GpsSet);
AppRegistry.registerComponent("WarnDeal", () => WarnDeal);
AppRegistry.registerComponent("Main", () => Main);
AppRegistry.registerComponent("TestListView", () => TestListView);
AppRegistry.registerComponent("WarningList", () => WarningList);
AppRegistry.registerComponent("WarningList2", () => WarningList2);
AppRegistry.registerComponent("Login", () => Login);
AppRegistry.registerComponent("TrackPlay", () => TrackPlay);
AppRegistry.registerComponent("WarnLocation", () => WarnLocation);
AppRegistry.registerComponent("LoginView", () => LoginView);
AppRegistry.registerComponent("UnusualTogether", () => UnusualTogether);
AppRegistry.registerComponent("LoadingReact", () => LoadingReact);