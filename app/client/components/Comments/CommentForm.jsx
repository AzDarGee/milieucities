import React, { Component } from 'react'
import css from './comments.scss'
import i18n from './locale'

export default class CommentForm extends Component {

  constructor(props) {
    super(props);
    this.state = {};
    this.handleChange = (e) => this.setState({ body: e.target.value });
    this.submitForm = (e) => this._submitForm(e);
    this.checkForUnsavedComment = (comment) => this._checkForUnsavedComment(comment);
  }

  componentDidMount() {
    this.checkForUnsavedComment(this.props.unsavedComment)
  }

  componentWillReceiveProps(nextProps) {
    this.checkForUnsavedComment(nextProps.unsavedComment)
  }

  _checkForUnsavedComment(unsavedComment) {
    if (unsavedComment && unsavedComment.parentId === this.props.parentId) {
      this.setState({ body: unsavedComment.body })
    }
  }

  _submitForm(e) {
    e.preventDefault();
    if (!this.props.acceptedPrivacyPolicy) {
      window.flash('alert', 'You must accept the Privacy Policy in order to comment.')
    } else {
      this.props.handleSave(this.state.body, this.props.parentId);
      this.setState({ body: '' })

      if (this.props.toggleCommentForm) {
        this.props.toggleCommentForm();
      }
    }
  }

  render() {
    const { locale } = document.body.dataset;
    i18n.setLanguage(locale);

    return(
      <form id='new_comment' onSubmit={this.submitForm} className={css.commentForm}>
        <input name='utf8' type='hidden' value='✓' />
        {
          this.props.devSite.guelph &&
          <div className={css.privacy}>
            <p>{i18n.disclaimer}</p>
          </div>
        }
        <div className={css.wrapper}>
          <textarea
            className={css.textarea}
            value={this.state.body}
            onChange={this.handleChange}
            placeholder={i18n.whatDoYouThink}>
          </textarea>
        </div>
        {
          this.props.devSite.guelph && !this.props.acceptedPrivacyPolicy &&
          <div className={css.privacy}>
            <p>{i18n.privacyPolicy}</p>
            <input type="checkbox" id='accept_privacy_policy' onChange={ this.props.handleChangePrivacyPolicy } />
            <label htmlFor="accept_privacy_policy">{i18n.acceptPrivacyPolicy}</label>
          </div>
        }
        <div className={css.submitBtn}>
          {
            !this.props.currentUser &&
            <p>{i18n.logInToComment}</p>
          }
          <input type='submit' value={i18n.comment} className={`${css.submit} btn`}/>
        </div>
      </form>
    )
  }
}
