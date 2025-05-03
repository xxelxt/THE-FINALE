import {
  AppstoreAddOutlined,
  BarChartOutlined,
  BookOutlined,
  BoxPlotOutlined,
  BranchesOutlined,
  CalendarOutlined,
  CarOutlined,
  CheckOutlined,
  CloudUploadOutlined,
  CopyrightOutlined,
  DatabaseOutlined,
  DisconnectOutlined,
  DollarOutlined,
  DropboxOutlined,
  EuroCircleOutlined,
  FileTextOutlined,
  FireOutlined,
  FormOutlined,
  FundViewOutlined,
  GiftOutlined,
  GlobalOutlined,
  GoldOutlined,
  GroupOutlined,
  InstagramOutlined,
  LaptopOutlined,
  LockOutlined,
  LogoutOutlined,
  MailOutlined,
  MessageOutlined,
  MoneyCollectOutlined,
  OrderedListOutlined,
  PaperClipOutlined,
  PieChartOutlined,
  PlusOutlined,
  ProjectOutlined,
  QrcodeOutlined,
  QuestionCircleOutlined,
  RadarChartOutlined,
  RiseOutlined,
  SettingOutlined,
  ShopOutlined,
  ShoppingCartOutlined,
  SkinOutlined,
  SlidersOutlined,
  SnippetsOutlined,
  StarOutlined,
  StockOutlined,
  ThunderboltOutlined,
  ToolOutlined,
  TransactionOutlined,
  TranslationOutlined,
  TrophyOutlined,
  UngroupOutlined,
  UserAddOutlined,
  UsergroupAddOutlined,
  UserOutlined,
  UserSwitchOutlined,
  WalletOutlined,
} from '@ant-design/icons';
import { FiClock, FiImage } from 'react-icons/fi';
import {
  HiOutlineChartBar,
  HiOutlineClipboardList,
  HiOutlinePuzzle,
  HiOutlineReceiptRefund,
} from 'react-icons/hi';
import {
  BsBarChart,
  BsCalendarCheck,
  BsClockHistory,
  BsFillDiagram3Fill,
  BsImage,
  BsInfoCircle,
  BsLightningCharge,
} from 'react-icons/bs';
import {
  MdDeliveryDining,
  MdNotificationAdd,
  MdOutlineEmail,
  MdOutlineFastfood,
  MdOutlineNotificationsActive,
  MdOutlinePayment,
} from 'react-icons/md';
import { ImStatsDots, ImSubscript2 } from 'react-icons/im';
import { RiFileSettingsLine } from 'react-icons/ri';

import {
  TbBrandAirtable,
  TbSitemap,
  TbTriangleSquareCircle,
  TbTruckDelivery,
} from 'react-icons/tb';
import { AiOutlineClear, AiOutlineFieldTime } from 'react-icons/ai';
import { BiCategoryAlt, BiKnife, BiMapPin } from 'react-icons/bi';
import { GiPayMoney } from 'react-icons/gi';
import { GrAppleAppStore } from 'react-icons/gr';

export default function getSystemIcons(icon) {
  switch (icon) {
    case 'dashboard':
      return <PieChartOutlined />;
    case 'shop':
      return <ShopOutlined />;
    case 'gold':
      return <GoldOutlined />;
    case 'dropbox':
      return <MdOutlineFastfood />;
    case 'appStoreAdd':
      return <AppstoreAddOutlined />;
    case 'laptop':
      return <LaptopOutlined />;
    case 'appStore':
      return <BiCategoryAlt />;
    case 'settings':
      return <SettingOutlined />;
    case 'global':
      return <GlobalOutlined />;
    case 'moneyCollect':
      return <MoneyCollectOutlined />;
    case 'branches':
      return <BranchesOutlined />;
    case 'branchesOutlined':
      return <BranchesOutlined />;
    case 'user':
      return <UserOutlined />;
    case 'userSwitch':
      return <UserSwitchOutlined />;
    case 'userAdd':
      return <UserAddOutlined />;
    case 'calendar':
      return <CalendarOutlined />;
    case 'BsCalendarCheck':
      return <BsCalendarCheck />;
    case 'euroCircle':
      return <EuroCircleOutlined />;
    case 'translation':
      return <TranslationOutlined />;
    case 'project':
      return <ProjectOutlined />;
    case 'database':
      return <DatabaseOutlined />;
    case 'tool':
      return <ToolOutlined />;
    case 'disconnect':
      return <DisconnectOutlined />;
    case 'orderedList':
      return <OrderedListOutlined />;
    case 'form':
      return <FormOutlined />;
    case 'wallet':
      return <WalletOutlined />;
    case 'userGroupAdd':
      return <UsergroupAddOutlined />;
    case 'questionCircle':
      return <QuestionCircleOutlined />;
    case 'transaction':
      return <TransactionOutlined />;
    case 'fiShoppingCart':
      return <ShoppingCartOutlined />;
    case 'OrderedListOutlined':
      return <OrderedListOutlined />;
    case 'CiViewBoard':
      return <HiOutlineClipboardList />;
    case 'fiImage':
      return <FiImage />;
    case 'bsImage':
      return <BsImage />;
    case 'deliveryDining':
      return <MdDeliveryDining />;
    case 'thunderbolt':
      return <ThunderboltOutlined />;
    case 'notificationsActive':
      return <MdOutlineNotificationsActive />;
    case 'imSubscript':
      return <ImSubscript2 />;
    case 'caretUp':
      return <BsBarChart />;
    case 'info':
      return <BsInfoCircle />;
    case 'RiPageSeparator':
      return <SnippetsOutlined />;
    case 'AiOutlineFieldTime':
      return <AiOutlineFieldTime />;
    case 'CarOutlined':
      return <CarOutlined />;
    case 'message':
      return <MessageOutlined />;
    case 'lock':
      return <LockOutlined />;
    case 'paperClip':
      return <PaperClipOutlined />;
    case 'star':
      return <StarOutlined />;
    case 'skin':
      return <SkinOutlined />;
    case 'book':
      return <BookOutlined />;
    case 'cloudUpload':
      return <CloudUploadOutlined />;
    case 'fire':
      return <FireOutlined />;
    case 'dollar':
      return <DollarOutlined />;
    case 'trophy':
      return <TrophyOutlined />;
    case 'instagram':
      return <InstagramOutlined />;
    case 'copyright':
      return <CopyrightOutlined />;
    case 'logout':
      return <LogoutOutlined />;
    case 'BsClockHistory':
      return <BsClockHistory />;
    case 'RiFileSettingsLine':
      return <RiFileSettingsLine />;
    case 'GiftOutlined':
      return <GiftOutlined />;
    case 'MdNotificationAdd':
      return <MdNotificationAdd />;
    case 'emailSettings':
      return <MdOutlineEmail />;
    case 'TbReceiptRefund':
      return <HiOutlineReceiptRefund />;
    case 'report':
      return <BarChartOutlined />;
    case 'overview':
      return <FundViewOutlined />;
    case 'products':
      return <DropboxOutlined />;
    case 'revenue':
      return <RiseOutlined />;
    case 'orders':
      return <RadarChartOutlined />;
    case 'variation':
      return <BoxPlotOutlined />;
    case 'CaretUpOutlined':
      return <HiOutlineChartBar style={{ marginRight: '13px' }} />;
    case 'careerCategory':
      return <BiCategoryAlt />;
    case 'categories':
      return <SlidersOutlined />;
    case 'stock':
      return <StockOutlined />;
    case 'TbTruckDelivery':
      return <TbTruckDelivery />;
    case 'TbSitemap':
      return <TbSitemap />;
    case 'MdOutlineTableBar':
      return <TbBrandAirtable />;
    case 'AiOutlineClear':
      return <AiOutlineClear />;
    case 'SlPuzzle':
      return <HiOutlinePuzzle />;
    case 'ImStatsDots':
      return <ImStatsDots />;
    case 'extras':
      return <PlusOutlined />;
    case 'referral':
      return <BsFillDiagram3Fill />;
    case 'mail':
      return <MailOutlined />;
    case 'moneyOut':
      return <GiPayMoney />;
    case 'groupOutlined':
      return <GroupOutlined />;
    case 'unGroupOutlined':
      return <UngroupOutlined />;
    case 'GrAppleAppStore':
      return <GrAppleAppStore />;
    case 'lightning':
      return <BsLightningCharge />;
    case 'clock':
      return <FiClock />;
    case 'payload':
      return <MdOutlinePayment />;
    case 'recept':
      return <TbTriangleSquareCircle />;
    case 'BookOutlined':
      return <BookOutlined />;
    case 'BiMapPin':
      return <BiMapPin />;
    case 'FileTextOutlined':
      return <FileTextOutlined />;
    case 'check':
      return <CheckOutlined />;
    case 'QrcodeOutlined':
      return <QrcodeOutlined />;
    case 'QuestionCircleOutlined':
      return <QuestionCircleOutlined />;
    case 'knife':
      return <BiKnife />;
    default:
      break;
  }
}
