require 'rails_helper'

FactoryBot.define do
  factory :article do
    title { "My Article" }

    after(:build) do |article, _evaluator|
      if article.sections.present?
        # Take the sections explicitly, got nothing else to do.
      else
        # Build a list of sections implicitly
        article.sections << build_list(:section, 1, article: article)
        # article.sections = build_list(:section, 1, article: article)
      end
    end
  end

  factory :section do
    article
  end
end

RSpec.describe 'Article factory' do
  describe 'factory' do
    it 'is valid by default' do
      expect(build(:article)).to be_valid
    end

    context 'without sections passed in explicitly' do
      it 'creates sections automaticaly' do
        expect { create(:article) }.to_not raise_error

        expect(Article.count).to eql(1)
        expect(Section.count).to eql(1)
      end
    end

    context 'with sections passed in explicitly' do
      it 'does NOT create additional sections' do
        section = build(:section)

        expect(Section.count).to eql(0)
        expect(Article.count).to eql(0)

        expect { create(:article, sections: [section]) }.to_not raise_error

        expect(Section.count).to eql(1)
        expect(Article.count).to eql(1)
      end
    end
  end
end

RSpec.describe 'Section factory' do
  it 'is valid by default' do
    expect(build(:section)).to be_valid
  end

  describe '.build' do
    context 'with an explicit article' do
      subject(:build_section) { build :section, article: article }
      let(:article) { build :article }

      it 'builds a section' do
        expect(build_section).to be_kind_of(Section)
        expect(build_section).to_not be_persisted
      end

      it 'builds an article associated with the section' do
        expect(build_section.article).to eql(article)
        expect(build_section.article).to be_kind_of(Article)
        expect(build_section.article).to_not be_persisted
      end

      it 'does NOT persist any sections' do
        expect { build_section }.to_not change { Section.count }.from(0)
      end

      it 'does NOT persist any articles' do
        expect { build_section }.to_not change { Article.count }.from(0)
      end
    end

    context 'without an explicit article' do
      subject(:build_section) { build :section }

      it 'builds a section' do
        expect(build_section).to be_kind_of(Section)
        expect(build_section).to_not be_persisted
      end

      it 'builds an article associated with the section' do
        expect(build_section.article).to be_kind_of(Article)
        expect(build_section.article).to_not be_persisted
      end

      it 'does NOT persist any sections' do
        expect { build_section }.to_not change { Section.count }.from(0)
      end

      it 'does NOT persist any articles' do
        expect { build_section }.to_not change { Article.count }.from(0)
      end
    end
  end

  describe '.create' do
    context 'with an explicit article' do
      subject(:create_section) { create :section, article: article }
      let(:article) { build :article }

      it 'creates a section' do
        expect(create_section).to be_kind_of(Section)
        expect(create_section).to be_persisted
      end

      it 'creates an article associated with the section' do
        expect(create_section.article).to eql(article)
        expect(create_section.article).to be_kind_of(Article)
        expect(create_section.article).to be_persisted
      end

      it 'creates ONLY one section explicitly' do
        expect { create_section }.to change { Section.count }.by(1)
      end

      it 'creates ONLY one article implicitly' do
        expect { create_section }.to change { Article.count }.by(1)
      end
    end

    context 'without an explicit article' do
      subject(:create_section) { create :section }

      it 'creates a section' do
        expect(create_section).to be_kind_of(Section)
        expect(create_section).to be_persisted
      end

      it 'creates an article associated with the section' do
        expect(create_section.article).to be_kind_of(Article)
        expect(create_section.article).to be_persisted
      end

      it 'creates ONLY one section explicitly' do
        expect { create_section }.to change { Section.count }.by(1)
      end

      it 'creates ONLY one article implicitly' do
        expect { create_section }.to change { Article.count }.by(1)
      end
    end
  end
end
