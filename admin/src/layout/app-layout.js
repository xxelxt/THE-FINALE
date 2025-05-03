import React, { Suspense, useEffect } from 'react';
import { Outlet } from 'react-router-dom';
import { batch, shallowEqual, useDispatch, useSelector } from 'react-redux';
import { Layout } from 'antd';
import Sidebar from '../components/sidebar';
import TabMenu from '../components/tab-menu';
import Footer from '../components/footer';
import languagesService from '../services/languages';
import { setDefaultLanguage, setLangugages } from '../redux/slices/formLang';
import { fetchAllShops } from '../redux/slices/allShops';
import { fetchCurrencies, fetchRestCurrencies } from '../redux/slices/currency';
import { data } from '../configs/menu-config';
import { setUserData } from '../redux/slices/auth';
import Loading from '../components/loading';
import { fetchMyShop } from '../redux/slices/myShop';
import SubscriptionsDate from '../components/subscriptions-date';

const { Content } = Layout;

const AppLayout = () => {
  const dispatch = useDispatch();
  const { languages } = useSelector((state) => state.formLang, shallowEqual);
  const { user } = useSelector((state) => state.auth, shallowEqual);
  const { direction, navCollapsed } = useSelector(
    (state) => state.theme.theme,
    shallowEqual,
  );

  const fetchLanguages = () => {
    languagesService.getAllActive().then(({ data }) => {
      batch(() => {
        dispatch(setLangugages(data));
        dispatch(
          setDefaultLanguage(
            data?.find((item) => item?.default)?.locale || 'en',
          ),
        );
      });
    });
  };

  useEffect(() => {
    const body = {
      page: 1,
      perPage: 1,
      status: 'approved',
    };
    if (!languages.length) {
      fetchLanguages();
    }
    if (user?.role === 'seller' || user?.role === 'moderator') {
      dispatch(fetchMyShop());
    }
    if (user?.role === 'admin' || user?.role === 'manager') {
      dispatch(fetchAllShops(body));
      dispatch(fetchCurrencies());
    } else {
      dispatch(fetchRestCurrencies());
    }
  }, []);

  useEffect(() => {
    // for development purpose only
    const userObj = {
      ...user,
      urls: data[user.role],
    };
    dispatch(setUserData(userObj));
  }, []);

  const getLayoutGutter = () => {
    // return navCollapsed ? SIDE_NAV_COLLAPSED_WIDTH : SIDE_NAV_WIDTH
    return navCollapsed ? 80 : 250;
  };

  const getLayoutDirectionGutter = () => {
    if (direction === 'ltr') {
      return { paddingLeft: getLayoutGutter(), minHeight: '100vh' };
    }
    if (direction === 'rtl') {
      return { paddingRight: getLayoutGutter(), minHeight: '100vh' };
    }
    return { paddingLeft: getLayoutGutter() };
  };

  return (
    <Layout className='app-container'>
      <Sidebar />
      <Layout className='app-layout' style={getLayoutDirectionGutter()}>
        <TabMenu />
        <Content className='p-3' style={{ flex: '1 0 70%' }}>
          <Suspense fallback={<Loading />}>
            <SubscriptionsDate />
            <Outlet />
          </Suspense>
        </Content>
        <Footer />
      </Layout>
    </Layout>
  );
};

export default AppLayout;
