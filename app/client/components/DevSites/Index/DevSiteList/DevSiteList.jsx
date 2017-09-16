import React, { Component } from 'react'
import css from './dev-site-list.scss'
import { replace, ceil } from 'lodash'
import i18n from './locale'
import { MAX_RESULTS_PER_PAGE } from '../../../Common/constants.js';

const commentPeriod = <img src={require('../../../../icons/in comment period.svg')} title='comment period' />;
const archived = <img src={require('../../../../icons/archived.svg')} title='archived' />;
const review = <img src={require('../../../../icons/review.svg')} title='review' />;
const siteplan = <img src={require('../../../../icons/siteplan.svg')} title="site plan " />;
const applicationRecieved = <img src={require('../../../../icons/apprecieved.svg')} title="application recieved " />;

export default class DevSiteList extends Component {
  constructor(props) {
    super(props);
    this.parent = this.props.parent;
    this.state = { cityRequestSaved: false };
    this.handleDevSiteClick = (e) => this._handleDevSiteClick(e);
    this.handleDevSiteMouseEnter = (e) => this.parent.setState({ hoverdDevSiteId: e.currentTarget.dataset.id });
    this.handleDevSiteMouseLeave = () => this.parent.setState({ hoverdDevSiteId: null });
    this.handlePreviousClick = (e) => this._handlePreviousClick(e);
    this.handleForwardClick = (e) => this._handleForwardClick(e);
    this.saveCityRequest = (e) => this._saveCityRequest(e);
  }
  _handleDevSiteClick(e) {
    e.preventDefault();
    if(this.parent.state.activeDevSiteId === e.currentTarget.dataset.id){
      this.parent.setState({ activeDevSiteId: null });
    }else{
      this.parent.setState({ activeDevSiteId: e.currentTarget.dataset.id });
    }
  }
  _handlePreviousClick(e) {
    e.preventDefault();
    if(this.props.page < 1) return;
    this.parent.setState({ page: (this.props.page - 1) }, () => this.parent.loadDevSites());
  }
  _handleForwardClick(e) {
    e.preventDefault();
    if((this.props.page + 1) === ceil(this.props.total / MAX_RESULTS_PER_PAGE)) return;
    this.parent.setState({ page: (this.props.page + 1) }, () => this.parent.loadDevSites());
  }
  _saveCityRequest(e) {
    e.preventDefault();

    if(e.which !== 13 && e.type !== 'click') {
      return false;
    }

    $.ajax({
      url: '/city_requests',
      dataType: 'JSON',
      type: 'POST',
      data: { city_request: { city: this.refs.cityRequest.value } },
      success: () => {
        window.flash('notice', i18n.cityRequestS);
      },
      error: error => {
        if(error.status == 422) {
          window.flash('alert', error.responseJSON.city);
        } else {
          window.flash('alert', i18n.cityRequestF);
        }
      }
    })
  }

  render() {
    const keys = {
      'Active Development': 'activedev',
      'Comment Period': 'commentopen',
      'Comment Period Closed': 'inactivedev'
    }
    let smallIcon;
    return(
      <div className={css.container}>
        {
          this.props.devSites.length === 0 && !this.props.loading &&
          <div className={css.empty}>
            <h3>{i18n.cantFind}</h3>
            <div className={css.inputSuggestion}>
              <h3>{i18n.suggestCity}</h3>
              <div className={css.inputContainer}>
                <input id='suggest-city' ref='cityRequest' type='text' placeholder='ex. Montreal, Quebec' onKeyPress={this.handleSubmit} />
                <a className='btn' href='#' onClick={this.saveCityRequest}>Save</a>
              </div>
            </div>
          </div>
        }
        {
          this.props.devSites.length > 0 &&
          <div>
            <div className={css.pagination}>
              <a href="#" onClick={this.handlePreviousClick} className={this.props.page === 0 ? css.disableleftarrow : css.leftarrow}></a>
              {this.props.page + 1} / {ceil(this.props.total / MAX_RESULTS_PER_PAGE)}
              <a href="#" onClick={this.handleForwardClick} className={(this.props.page+1) === ceil(this.props.total / MAX_RESULTS_PER_PAGE) ? css.disablerightarrow : css.rightarrow}></a>
            </div>
            {
              this.props.devSites.map((devSite, index) => {
                switch(devSite.status){
                  case 'Application Received':
                  smallIcon = applicationRecieved;
                  break;
                  case 'Application Complete, Comment Period Open':
                  smallIcon = commentPeriod;
                  break;
                  case 'Planning Review Stage':
                  smallIcon = siteplan;
                  break;
                  case 'Revision':
                  smallIcon = review;
                  break;
                  case 'Decision':
                  smallIcon = archived
                  break;
                }
                return(
                  <a href="#"
                      onClick={this.handleDevSiteClick}
                      onFocus={this.handleDevSiteMouseEnter}
                      onBlur={this.handleDevSiteMouseLeave}
                      onMouseEnter={this.handleDevSiteMouseEnter}
                      onMouseLeave={this.handleDevSiteMouseLeave}
                      data-id={devSite.id}
                      className={this.props.activeDevSiteId == devSite.id ? css.activeitem : css.item}
                      key={index}
                  >
                    <img src={devSite.image_url} className={css.previewImage} />
                    <div className={css.infoContainer}>
                      <h3 className={css.address}>{devSite.street}</h3>
                      { devSite.application_files &&
                        devSite.application_files.map((file, index) => (
                          <div key={index} className={css.info}>{file.application_type} ({file.file_number})</div>
                        ))
                      }
                      <div className={css.info}>{devSite.current_status}</div>
                      <div className={css.icons}>{smallIcon}</div>
                      <div className={css.description} dangerouslySetInnerHTML={{__html: devSite.description}}></div>
                    </div>
                  </a>
                )
              })
            }
            <div className={css.pagination}>
              <a href="#" onClick={this.handlePreviousClick} className={this.props.page === 0 ? css.disableleftarrow : css.leftarrow}></a>
              {this.props.page + 1} / {ceil(this.props.total / MAX_RESULTS_PER_PAGE)}
              <a href="#" onClick={this.handleForwardClick} className={(this.props.page+1) === ceil(this.props.total / MAX_RESULTS_PER_PAGE) ? css.disablerightarrow : css.rightarrow}></a>
            </div>
          </div>
        }
      </div>
    );
  }
}
