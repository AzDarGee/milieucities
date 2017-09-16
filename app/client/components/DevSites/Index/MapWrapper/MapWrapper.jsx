import React, { Component } from 'react'
import { render } from 'react-dom'
import css from './map-wrapper.scss'
import MapSearch from '../MapSearch/MapSearch'
import DevSiteList from '../DevSiteList/DevSiteList'
import DevSitePreview from '../../Preview/Preview'
import MapAwesome from '../Map/Map'
import { Map } from 'immutable'
import { debounce, omitBy, isNil } from 'lodash'
import MapHeader from '../../../Layout/Header/MapHeader'

export default class MapWrapper extends Component {
  constructor(props) {
    super(props);
    const devSiteMap = document.querySelector('#dev-site-map');

    this.state = {
                   loading: true,
                   page: parseInt(getParameterByName('page')) || 0,
                   devSites: [],
                   municipalities: [],
                   latitude: getParameterByName('latitude') || this.props.latitude || 43.544476130796994,
                   longitude: getParameterByName('longitude') || this.props.longitude || -80.25039908384068,
                   zoom: getParameterByName('zoom') || 11.5,
                   ward: getParameterByName('ward'),
                   status: getParameterByName('status'),
                   year: getParameterByName('year'),
                   municipality: getParameterByName('municipality'),
                   activeDevSiteId: getParameterByName('activeDevSiteId'),
                   isMobile: (window.innerWidth < 992),
                   mobileSearch: false
                 };

    this.search = () => this._search();
    this.loadDevSites = () => this._loadDevSites();
    this.loadMunicipalities = () => this._loadMunicipalities();
    this.updateSearchParams = (params, callback) => this._updateSearchParams(params, callback);
    this.params = () => this._params();
    this.handleOpenSearch = () => this._handleOpenSearch();
    this.loadDevSites();
    this.loadMunicipalities();

    window.addEventListener('resize',
      debounce(() => {
        this.setState({ isMobile: (window.innerWidth < 992) })
      }, 100)
    );
  }

  componentDidUpdate(prevProps, prevState) {
    const { locale } = document.body.dataset;
    const path = `${window.location.pathname}?${$.param(this.params())}`;
    window.history.replaceState({ path },'', path);
  }

  _params() {
    const { query, page, latitude, longitude, zoom, status, year, municipality, ward, activeDevSiteId } = this.state;
    return omitBy({ query, page, latitude, longitude, zoom, status, year, municipality, ward, activeDevSiteId }, isNil);
  };

  _loadDevSites() {
    const scrollToTop = () => { if (this.refs.sidebar) this.refs.sidebar.scrollTop = 0 };
    $.getJSON(`/dev_sites`, this.params(), json => {
      this.setState({ devSites: (json.dev_sites || []), total: json.total, loading: false }, scrollToTop);
    });
  }

  _loadMunicipalities() {
    $.getJSON(`/municipalities`, municipalities => {
      this.setState({ municipalities });
    });
  }

  _handleOpenSearch() {
    if (this.state.mobileSearch) {
      this.setState({
        mobileSearch: false
      })
    } else {
      this.setState({
        mobileSearch: true
      })
    }
  }

  _search() {
    const scrollToTop = () => { if (this.refs.sidebar) this.refs.sidebar.scrollTop = 0 };
    this.setState({ loading: true });

    $.getJSON(`/dev_sites`, this.params(), json => {
      if(json.dev_sites && (!this.state.longitude || !this.state.latitude)) {
        this.setState({ longitude: json.dev_sites[0].longitude, latitude: json.dev_sites[0].latitude });
      }
      this.setState({ page: 0, devSites: (json.dev_sites || []), total: json.total, loading: false }, scrollToTop);
    });
  }

  _updateSearchParams(params, callback) {
    this.setState(params, callback)
  }

  render() {
    const { mobileSearch, isMobile, activeDevSiteId } = this.state;
    return(
      <div>
        <MapHeader mobileSearch={this.handleOpenSearch} activeDevSiteId={activeDevSiteId}/>
          {
            !isMobile &&
            <div className={css.container}>
              <div className={css.sidebar} ref='sidebar'>
                <MapSearch
                  {...this.state}
                  updateSearchParams={this.updateSearchParams}
                  search={this.search}
                />
                <DevSiteList {...this.state} parent={this} />
              </div>
              <div className={css.content}>
                {
                  activeDevSiteId &&
                  <DevSitePreview id={this.state.activeDevSiteId} parent={this} />
                }
                {
                  !activeDevSiteId &&
                  <MapAwesome {...this.state} parent={this} />
                }
              </div>
            </div>
          }
          {
            isMobile &&
            <div className={css.container}>
              <div className={css.content}>
                {
                  mobileSearch &&
                    <MapSearch {...this.state} search={this.search} updateSearchParams={this.updateSearchParams}/>
                }

                {
                  activeDevSiteId &&
                  <DevSitePreview id={this.state.activeDevSiteId} parent={this} notmobileSearch/>
                }
                {
                  !activeDevSiteId &&
                  <MapAwesome {...this.state} parent={this} />
                }
                <DevSiteList {...this.state} parent={this} />
              </div>
            </div>
          }
      </div>
    );
  }
}

document.addEventListener('turbolinks:load', () => {
  const devSiteMap = document.querySelector('#dev-site-map');
  if (devSiteMap) {
    const { userLongitude, userLatitude } = devSiteMap.dataset;
    render(
      <MapWrapper
        longitude={userLongitude}
        longitude={userLongitude}
      />, devSiteMap
    )
  }
})
